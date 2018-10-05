pageextension 50110 Headline extends "Headline RC Business Manager"
{
    layout
    {
        addafter(Control4)
        {
            field(NowPlaying; NowPlaying)
            {
                ApplicationArea = All;
            }
            field(LastGame; LastGame)
            {
                ApplicationArea = All;
            }
        }
    }


    var
        LastGame: Text;
        NowPlaying: Text;
        Text001: Label 'Neka labela', Comment = 'Moj prvi prevod test tag pull request dodatno';


    trigger OnOpenPage()
    var
        Result: Record "Russia 2018 Results";
        ResultMgt: Codeunit "Russia 2018 Results management";
        HeadlineMgt: Codeunit "Headline Management";
    begin
        ResultMgt.Refresh();
        Result.SetRange(MatchStatus, Result.MatchStatus::Finished);
        If Result.FindLast() then
            LastGame := 'Poslednja tekma: ' + Result.HomeTeam + ' ' + Result.HomeTeamResult + ' - ' +
                            Result.AwayTeamResult + ' ' + Result.AwayTeam;
        HeadlineMgt.GetHeadlineText('Russia 2018 World Cup', LastGame, LastGame);

        Result.SetRange(MatchStatus, Result.MatchStatus::Playing);
        If Result.FindLast() then
            NowPlaying := 'Trenutno se igra: ' + Result.HomeTeam + ' ' + Result.HomeTeamResult + ' - ' +
                            Result.AwayTeamResult + ' ' + Result.AwayTeam
        else
            NowPlaying := 'Nema tekme trenutno';
        HeadlineMgt.GetHeadlineText('Russia 2018 World Cup', NowPlaying, NowPlaying);
    end;
}