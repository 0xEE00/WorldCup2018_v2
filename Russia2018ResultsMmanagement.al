codeunit 50110 "Russia 2018 Results management"
{
    trigger OnRun()
    begin
        Refresh();
    end;

    procedure Refresh()
    var
        Results: Record "Russia 2018 Results";
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: Text;
        i: Integer;
    begin
        Results.DeleteAll();
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('https://api.fifa.com/api/v1/calendar/matches?idseason=254645&idcompetition=17&language=en-GB&count=100', ResponseMessage) then
            Error('Nije uspeo poziv ka web servisu');
        if not ResponseMessage.IsSuccessStatusCode then
            Error('Web servis vraca gresku:\' +
                  'Status code: %1' +
                  'Opis: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(JsonText);

        JsonToken.ReadFrom(JsonText);
        JsonObject := JsonToken.AsObject();
        JsonObject.SelectToken('Results', JsonToken);
        JsonArray := JsonToken.AsArray();
        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            InsertResults(JsonToken);
        end;
    end;

    local procedure InsertResults(JsonToken: JsonToken)
    var
        JsonObject: JsonObject;
        Results: Record "Russia 2018 Results";
        JsonObjectChild: JsonObject;
        JsonTokenChild: JsonToken;
        JsonArrayChild: JsonArray;
    begin
        JsonObject := JsonToken.AsObject;

        Results.init;
        Evaluate(Results.MathNo, SelectJsonToken(JsonObject, '$.MatchNumber'));
        if JsonObject.SelectToken('$.Home.TeamName', JsonTokenChild) then
            Results.HomeTeam := GetChildArrayValue(JsonTokenChild, '$.Description');
        Results.HomeTeamResult := SelectJsonToken(JsonObject, '$.HomeTeamScore');

        if JsonObject.SelectToken('$.Away.TeamName', JsonTokenChild) then
            Results.AwayTeam := GetChildArrayValue(JsonTokenChild, '$.Description');
        Results.AwayTeamResult := SelectJsonToken(JsonObject, '$.AwayTeamScore');

        Evaluate(Results.MatchStatus, SelectJsonToken(JsonObject, '$.MatchStatus'));

        if JsonObject.SelectToken('$.Stadium.CityName', JsonTokenChild) then
            Results.City := GetChildArrayValue(JsonTokenChild, '$.Description');

        if JsonObject.SelectToken('$.GroupName', JsonTokenChild) then
            Results."Group Name" := GetChildArrayValue(JsonTokenChild, '$.Description');

        Results.DateAndTime := GetDateTime(SelectJsonToken(JsonObject, '$.LocalDate'));

        Evaluate(Results."Home Tactics", SelectJsonToken(JsonObject,'$.Home.Tactics'));

        Evaluate(Results."Away Tactics", SelectJsonToken(JsonObject,'$.Away.Tactics'));
        Results.Insert;
    end;

    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text): Text
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            exit('');
        if JsonToken.AsValue().IsNull() then
            exit('');
        exit(JsonToken.AsValue().AsText());
    end;

    local procedure GetChildArrayValue(JsonTokenChild: JsonToken; ChildName: text): Text
    var
        JsonObjectChild: JsonObject;
        JsonArrayChild: JsonArray;
    begin
        JsonArrayChild := JsonTokenChild.AsArray();
        if not JsonArrayChild.Get(0, JsonTokenChild) then
            exit('');
        JsonObjectChild := JsonTokenChild.AsObject();
        exit(SelectJsonToken(JsonObjectChild, ChildName));
    end;

    local procedure GetDateTime(Json: Text): DateTime
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        TheTime: Time;
    begin
        Evaluate(Day, CopyStr(Json, 9, 2));
        Evaluate(Month, CopyStr(Json, 6, 2));
        Evaluate(Year, CopyStr(Json, 1, 4));
        Evaluate(TheTime, CopyStr(Json, 12, 8));
        exit(CreateDateTime(DMY2Date(Day, Month, Year), TheTime));
    end;
}