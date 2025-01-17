type t = Js.Date.t;

[@bs.val] [@bs.module "date-fns"]
external dateFormat: (t, string) => string = "format";

[@bs.val] [@bs.module "date-fns"] external dateParse: string => t = "parse";

let parse = s => s |> dateParse;

type format =
  | OnlyDate
  | DateWithYearAndTime;

let format = (f, t) => {
  let formatString =
    switch (f) {
    | OnlyDate => "Do MMM YYYY"
    | DateWithYearAndTime => "Do MMM YYYY HH:mm"
    };
  dateFormat(t, formatString);
};

let stingToFormatedTime = (f, t) => format(f, parse(t));
