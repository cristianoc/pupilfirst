[@bs.config {jsx: 3}];
[%bs.raw {|require("./CoursesReview__FeedbackEditor.css")|}];

open CoursesReview__Types;

type selectionItem = {
  itemIndex: int,
  resultIndex: int,
};

type selection = list(selectionItem);

let str = React.string;

let selectChecklist = (itemIndex, resultIndex, setSelecton) => {
  setSelecton(selection =>
    selection |> List.append([{itemIndex, resultIndex}])
  );
};

let unSelectChecklist = (itemIndex, resultIndex, setSelecton) => {
  setSelecton(selection =>
    selection
    |> List.filter(item =>
         !(item.itemIndex == itemIndex && item.resultIndex == resultIndex)
       )
  );
};

let checkboxOnChange = (itemIndex, resultIndex, setSelecton, event) => {
  ReactEvent.Form.target(event)##checked
    ? selectChecklist(itemIndex, resultIndex, setSelecton)
    : unSelectChecklist(itemIndex, resultIndex, setSelecton);
};

let generateFeedback =
    (reviewChecklist, selection, feedback, updateFeedbackCB) => {
  let newFeedback =
    feedback
    ++ "\n\n"
    ++ (
      reviewChecklist
      |> Array.mapi((i, reviewChecklistItem) => {
           let resultIndexList =
             selection
             |> List.filter(selectionItem => selectionItem.itemIndex == i)
             |> List.map(item => item.resultIndex);

           reviewChecklistItem
           |> ReviewChecklistItem.result
           |> Array.mapi((index, resultItem) =>
                resultIndexList |> List.mem(index)
                  ? switch (resultItem |> ReviewChecklistResult.feedback) {
                    | Some(feedback) => [feedback]
                    | None => []
                    }
                  : []
              )
           |> Array.to_list
           |> List.flatten;
         })
      |> Array.to_list
      |> List.flatten
      |> Array.of_list
      |> Js.Array.joinWith("\n\n")
    );
  updateFeedbackCB(newFeedback);
};

[@react.component]
let make = (~reviewChecklist, ~feedback, ~updateFeedbackCB, ~showEditorCB) => {
  let (selection, setSelecton) = React.useState(() => []);

  <div className="relative bg-gray-100 rounded-lg p-2 md:p-4">
    <div className="absolute right-0 top-0 -mt-9">
      <button
        className="flex items-center btn btn-small btn-primary-ghost"
        onClick={_ => showEditorCB()}>
        <i className="far fa-edit" />
        <span className="ml-2 leading-tight"> {"Edit Checklist" |> str} </span>
      </button>
    </div>
    {reviewChecklist
     |> Array.mapi((itemIndex, reviewChecklistItem) =>
          <div
            key={itemIndex |> string_of_int}
            ariaLabel={"checklist-item-" ++ (itemIndex |> string_of_int)}>
            <h4
              className="text-base font-semibold mt-4 md:mt-0 w-full md:w-4/5">
              {reviewChecklistItem |> ReviewChecklistItem.title |> str}
            </h4>
            <div>
              {reviewChecklistItem
               |> ReviewChecklistItem.result
               |> Array.mapi((resultIndex, checklistItem) =>
                    <div
                      className="px-2 md:px-4 mt-2"
                      ariaLabel={
                        "result-item-" ++ (resultIndex |> string_of_int)
                      }
                      key={
                        (itemIndex |> string_of_int)
                        ++ (resultIndex |> string_of_int)
                      }>
                      <Checkbox
                        id={
                          "review-checkbox-"
                          ++ (itemIndex |> string_of_int)
                          ++ (resultIndex |> string_of_int)
                        }
                        label={checklistItem |> ReviewChecklistResult.title}
                        onChange={checkboxOnChange(
                          itemIndex,
                          resultIndex,
                          setSelecton,
                        )}
                      />
                      <div className="pl-7">
                        <CoursesReview__ChecklistShowFeedback
                          feedback={
                            checklistItem |> ReviewChecklistResult.feedback
                          }
                        />
                      </div>
                    </div>
                  )
               |> React.array}
            </div>
          </div>
        )
     |> React.array}
    <div className="text-center max-w-xs mx-auto mt-6">
      <button
        className="btn btn-primary btn-large w-full "
        disabled={selection |> ListUtils.isEmpty}
        onClick={_ =>
          generateFeedback(
            reviewChecklist,
            selection,
            feedback,
            updateFeedbackCB,
          )
        }>
        {"Generate Feedback" |> str}
      </button>
    </div>
  </div>;
};
