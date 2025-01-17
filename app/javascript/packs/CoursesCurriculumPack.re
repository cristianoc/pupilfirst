[@bs.config {jsx: 3}];

open CoursesCurriculum__Types;

let decodeProps = json =>
  Json.Decode.(
    json |> field("authenticityToken", string),
    json |> field("course", Course.decode),
    json |> field("levels", list(Level.decode)),
    json |> field("targetGroups", list(TargetGroup.decode)),
    json |> field("targets", list(Target.decode)),
    json |> field("submissions", list(LatestSubmission.decode)),
    json |> field("team", Team.decode),
    json |> field("coaches", list(Coach.decode)),
    json |> field("users", list(User.decode)),
    json |> field("evaluationCriteria", list(EvaluationCriterion.decode)),
    json |> field("preview", bool),
  );

let (
  authenticityToken,
  course,
  levels,
  targetGroups,
  targets,
  submissions,
  team,
  coaches,
  users,
  evaluationCriteria,
  preview,
) =
  DomUtils.parseJsonAttribute() |> decodeProps;

ReactDOMRe.renderToElementWithId(
  <CoursesCurriculum
    authenticityToken
    course
    levels
    targetGroups
    targets
    submissions
    team
    coaches
    users
    evaluationCriteria
    preview
  />,
  "react-root",
);
