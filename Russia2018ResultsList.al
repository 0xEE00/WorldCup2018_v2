page 50110 "Russia 2018 Results List"
{

    PageType = List;
    SourceTable = "Russia 2018 Results";
    CaptionML = ENU = 'Russia 2018 Results';
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MathNo; MathNo)
                {
                    ApplicationArea = All;
                }
                field(HomeTeam; HomeTeam)
                {
                    ApplicationArea = All;
                }
                field(HomeTeamResult; HomeTeamResult)
                {
                    ApplicationArea = All;
                }
                field(AwayTeam; AwayTeam)
                {
                    ApplicationArea = All;
                }
                field(AwayTeamResult; AwayTeamResult)
                {
                    ApplicationArea = All;
                }
                field(MatchStatus; MatchStatus)
                {
                    ApplicationArea = All;
                }
                field("Home Tactics"; "Home Tactics")
                {
                    ApplicationArea = All;
                }

                field("Away Tactics"; "Away Tactics")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field(DateAndTime; DateAndTime)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshResults)
            {
                CaptionML = ENU = 'Refresh Results';
                Promoted = true;
                PromotedCategory = Process;
                Image = RefreshLines;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    RefreshResults();
                    CurrPage.Update;
                    if FindFirst then;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Result: Codeunit "Russia 2018 Results management";
    begin
        Result.Refresh();
    end;

}