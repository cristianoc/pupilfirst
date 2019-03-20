type t = {
  grade: int,
  label: string,
};

let grade = t => t.grade;

let label = t => t.label;

let create = (grade, label) => {grade, label};

let empty = grade => {grade, label: ""};

let update = (label, t) => {...t, label};

let encode = t =>
  Json.Encode.(
    object_([("grade", t.grade |> int), ("label", t.label |> string)])
  );

let asJsType = t => {"grade": t.grade, "label": t.label};