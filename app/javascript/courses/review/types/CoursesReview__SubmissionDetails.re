type t = {
  submissions: array(CoursesReview__Submission.t),
  targetId: string,
  targetTitle: string,
  userNames: string,
  levelNumber: string,
  levelId: string,
  evaluationCriteria: array(EvaluationCriterion.t),
  reviewChecklist: array(CoursesReview__ReviewChecklistItem.t),
  targetEvaluationCriteriaIds: array(string),
};
let submissions = t => t.submissions;
let targetId = t => t.targetId;
let targetTitle = t => t.targetTitle;
let levelNumber = t => t.levelNumber;
let userNames = t => t.userNames;
let evaluationCriteria = t => t.evaluationCriteria;
let reviewChecklist = t => t.reviewChecklist;
let targetEvaluationCriteriaIds = t => t.targetEvaluationCriteriaIds;
let make =
    (
      ~submissions,
      ~targetId,
      ~targetTitle,
      ~userNames,
      ~levelNumber,
      ~evaluationCriteria,
      ~levelId,
      ~reviewChecklist,
      ~targetEvaluationCriteriaIds,
    ) => {
  submissions,
  targetId,
  targetTitle,
  userNames,
  levelNumber,
  evaluationCriteria,
  levelId,
  reviewChecklist,
  targetEvaluationCriteriaIds,
};

let decodeJS = details =>
  make(
    ~submissions=details##submissions |> CoursesReview__Submission.makeFromJs,
    ~targetId=details##targetId,
    ~targetTitle=details##targetTitle,
    ~userNames=details##userNames,
    ~levelNumber=details##levelNumber,
    ~levelId=details##levelId,
    ~targetEvaluationCriteriaIds=details##targetEvaluationCriteriaIds,
    ~evaluationCriteria=
      details##evaluationCriteria
      |> Js.Array.map(ec =>
           EvaluationCriterion.make(~id=ec##id, ~name=ec##name)
         ),
    ~reviewChecklist=
      details##reviewChecklist |> CoursesReview__ReviewChecklistItem.makeFromJs,
  );

let updateSubmission = (t, submission) =>
  make(
    ~submissions=
      t.submissions
      |> Js.Array.filter(s =>
           s
           |> CoursesReview__Submission.id
           != (submission |> CoursesReview__Submission.id)
         )
      |> Array.append([|submission|]),
    ~targetId=t.targetId,
    ~targetTitle=t.targetTitle,
    ~userNames=t.userNames,
    ~levelNumber=t.levelNumber,
    ~levelId=t.levelId,
    ~evaluationCriteria=t.evaluationCriteria,
    ~reviewChecklist=t.reviewChecklist,
    ~targetEvaluationCriteriaIds=t.targetEvaluationCriteriaIds,
  );
let failed = submission =>
  switch (
    submission |> CoursesReview__Submission.evaluatedAt,
    submission |> CoursesReview__Submission.passedAt,
  ) {
  | (Some(_), Some(_)) => false
  | (Some(_), None)
  | (None, Some(_))
  | (None, None) => true
  };

let feedbackSent = submission =>
  submission |> CoursesReview__Submission.feedback |> ArrayUtils.isNotEmpty;

let makeSubmissionInfo = (t, submission) =>
  CoursesReview__SubmissionInfo.make(
    ~id=submission |> CoursesReview__Submission.id,
    ~title=t.targetTitle,
    ~createdAt=submission |> CoursesReview__Submission.createdAt,
    ~levelId=t.levelId,
    ~userNames=t.userNames,
    ~status=
      Some(
        CoursesReview__SubmissionInfo.makeStatus(
          ~failed=failed(submission),
          ~feedbackSent=feedbackSent(submission),
        ),
      ),
  );

let updateReviewChecklist = (reviewChecklist, t) => {
  make(
    ~submissions=t.submissions,
    ~targetId=t.targetId,
    ~targetTitle=t.targetTitle,
    ~userNames=t.userNames,
    ~levelNumber=t.levelNumber,
    ~levelId=t.levelId,
    ~evaluationCriteria=t.evaluationCriteria,
    ~targetEvaluationCriteriaIds=t.targetEvaluationCriteriaIds,
    ~reviewChecklist,
  );
};
