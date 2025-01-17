[@bs.config {jsx: 3}];

open CoursesCurriculum__Types;

let str = React.string;

module LevelUpQuery = [%graphql
  {|
   mutation($courseId: ID!) {
    levelUp(courseId: $courseId){
      success
      }
    }
 |}
];

let handleSubmitButton = saving => {
  let submitButtonText = (title, iconClasses) =>
    <span> <FaIcon classes={iconClasses ++ " mr-2"} /> {title |> str} </span>;

  saving ?
    submitButtonText("Saving", "fas fa-spinner fa-spin") :
    submitButtonText("Level Up", "fas fa-flag");
};

let refreshPage = () => Webapi.Dom.(location |> Location.reload);

let createLevelUpQuery = (authenticityToken, course, setSaving, event) => {
  event |> ReactEvent.Mouse.preventDefault;
  setSaving(_ => true);
  LevelUpQuery.make(~courseId=course |> Course.id, ())
  |> GraphqlQuery.sendQuery(authenticityToken)
  |> Js.Promise.then_(response => {
       response##levelUp##success ? refreshPage() : setSaving(_ => false);
       Js.Promise.resolve();
     })
  |> ignore;
};

[@react.component]
let make = (~course, ~authenticityToken) => {
  let (saving, setSaving) = React.useState(() => false);
  <button
    disabled=saving
    onClick={createLevelUpQuery(authenticityToken, course, setSaving)}
    className="btn btn-success btn-large w-full md:w-4/6 mt-4">
    {handleSubmitButton(saving)}
  </button>;
};