let component = ReasonReact.statelessComponent("TimelineEventsList");

let make =
    (
      ~timelineEvents,
      ~founders,
      ~replaceTimelineEvent,
      ~authenticityToken,
      ~notAcceptedIconUrl,
      ~verifiedIconUrl,
      ~gradeLabels,
      ~passGrade,
      ~coachName,
      _children,
    ) => {
  ...component,
  render: _self =>
    <div className="timeline-events-list__container">
      {timelineEvents
       |> List.map(te =>
            <TimelineEventCard
              key={te |> TimelineEvent.id |> string_of_int}
              timelineEvent=te
              founders
              replaceTimelineEvent
              authenticityToken
              notAcceptedIconUrl
              verifiedIconUrl
              gradeLabels
              passGrade
              coachName
            />
          )
       |> Array.of_list
       |> ReasonReact.array}
    </div>,
};
