table 50110 "Russia 2018 Results"
{
        
    fields
    {
        field(1; MathNo; Integer)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Match No.';

        }
        field(2; HomeTeam; text[100])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Home Team';
        }
        field(3; AwayTeam; text[100])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Away Team';
        }
        field(4; HomeTeamResult; text[2])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Home Team Result';
        }
        field(5; AwayTeamResult; Text[2])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Away Team Result';
        }
        field(6; City; text[100])
        {
            //DataClassification = ToBeClassified;
            Caption = 'City';
        }
        field(7; "Group Name"; text[10])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Group Name';
        }
        field(8; DateAndTime; DateTime)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Match Date and Time';
        }
        field(9; MatchStatus; Option)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Match Status';
            OptionMembers = Finished,"Not Started",,Playing,,,,,,,,,Preparing;

        }
        field(10; "Home Tactics"; Text[10])
        {
          Caption = 'Home Tactics';
        }
        field(11; "Away Tactics"; Text[10])
        {
          Caption = 'Away Tactics';
        }

    }

    procedure RefreshResults();
    var
        RefreshResults: Codeunit "Russia 2018 Results management";
    begin
        RefreshResults.Refresh();
    end;

}