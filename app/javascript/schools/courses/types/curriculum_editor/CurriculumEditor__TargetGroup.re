type t = {
  id: string,
  name: string,
  description: option(string),
  milestone: bool,
  levelId: string,
  sortIndex: int,
  archived: bool,
};

let id = t => t.id;

let name = t => t.name;

let description = t => t.description;

let milestone = t => t.milestone;

let levelId = t => t.levelId;

let archived = t => t.archived;

let decode = json =>
  Json.Decode.{
    id: json |> field("id", string),
    name: json |> field("name", string),
    description:
      json |> field("description", nullable(string)) |> Js.Null.toOption,
    levelId: json |> field("levelId", string),
    milestone: json |> field("milestone", bool),
    sortIndex: json |> field("sortIndex", int),
    archived: json |> field("archived", bool),
  };

let create = (id, name, description, milestone, levelId, sortIndex, archived) => {
  id,
  name,
  description,
  milestone,
  levelId,
  sortIndex,
  archived,
};

let updateList = (targetGroups, targetGroup) => {
  let oldTargetGroups =
    targetGroups |> List.filter(tg => tg.id !== targetGroup.id);
  oldTargetGroups |> List.rev |> List.append([targetGroup]) |> List.rev;
};

let sort = targetGroups =>
  targetGroups |> List.sort((x, y) => x.sortIndex - y.sortIndex);

let archive = (archived, t) => {...t, archived};

let find = (id, targetGroups) => targetGroups |> List.find(tg => tg.id == id);

let updateSortIndex = sortedTargetGroups =>
  sortedTargetGroups
  |> List.mapi((sortIndex, t) =>
       create(
         t.id,
         t.name,
         t.description,
         t.milestone,
         t.levelId,
         sortIndex,
         t.archived,
       )
     );
