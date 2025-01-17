[@bs.config {jsx: 3}];

open CoursesReview__Types;

let decodeProps = json =>
  Json.Decode.(
    json |> field("authenticityToken", string),
    json |> field("levels", array(Level.decode)),
    json |> field("pendingSubmissions", array(SubmissionInfo.decode)),
    json |> field("courseId", string),
    json |> field("gradeLabels", array(GradeLabel.decode)),
    json |> field("passGrade", int),
    json |> field("currentCoach", Coach.decode),
  );

let (
  authenticityToken,
  levels,
  pendingSubmissions,
  courseId,
  gradeLabels,
  passGrade,
  currentCoach,
) =
  DomUtils.parseJsonAttribute() |> decodeProps;

ReactDOMRe.renderToElementWithId(
  <CoursesReview__Root
    authenticityToken
    levels
    pendingSubmissions
    courseId
    gradeLabels
    passGrade
    currentCoach
  />,
  "react-root",
);
