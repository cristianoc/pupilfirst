exception UnknownKindOfLink(string);

type schoolStrings = {
  address: option(string),
  emailAddress: option(string),
  privacyPolicy: option(string),
  termsOfUse: option(string),
};

type file = {
  url: string,
  filename: string,
};

type schoolImages = {
  logoOnLightBg: option(file),
  logoOnDarkBg: option(file),
  icon: file,
};

type linkId = string;
type title = string;
type url = string;

type link =
  | HeaderLink(linkId, title, url)
  | FooterLink(linkId, title, url)
  | SocialLink(linkId, url);

type t = {
  schoolStrings,
  schoolImages,
  links: list(link),
};

let logoOnLightBg = t => t.schoolImages.logoOnLightBg;
let logoOnDarkBg = t => t.schoolImages.logoOnDarkBg;
let icon = t => t.schoolImages.icon;

let url = file => file.url;
let filename = file => file.filename;

let address = t => t.schoolStrings.address;
let emailAddress = t => t.schoolStrings.emailAddress;
let privacyPolicy = t => t.schoolStrings.privacyPolicy;
let termsOfUse = t => t.schoolStrings.termsOfUse;

let headerLinks = t =>
  t.links
  |> List.filter(l =>
       switch (l) {
       | HeaderLink(_, _, _) => true
       | FooterLink(_, _, _) => false
       | SocialLink(_, _) => false
       }
     );

let footerLinks = t =>
  t.links
  |> List.filter(l =>
       switch (l) {
       | HeaderLink(_, _, _) => false
       | FooterLink(_, _, _) => true
       | SocialLink(_, _) => false
       }
     );

let socialLinks = t =>
  t.links
  |> List.filter(l =>
       switch (l) {
       | HeaderLink(_, _, _) => false
       | FooterLink(_, _, _) => false
       | SocialLink(_, _) => true
       }
     );

let unpackLinks = links =>
  links
  |> List.map(l =>
       switch (l) {
       | HeaderLink(id, title, url)
       | FooterLink(id, title, url) => (id, title, url)
       | SocialLink(id, url) => (id, "", url)
       }
     );

let addLink = (link, t) => {...t, links: t.links @ [link]};

let removeLink = (linkId, t) => {
  ...t,
  links:
    t.links
    |> List.filter(l =>
         switch (l) {
         | HeaderLink(id, _, _)
         | FooterLink(id, _, _) => id != linkId
         | SocialLink(id, _) => id != linkId
         }
       ),
};

let optionalString = s =>
  switch (s |> String.trim) {
  | "" => None
  | nonEmptyString => Some(nonEmptyString)
  };

let updatePrivacyPolicy = (privacyPolicy, t) => {
  ...t,
  schoolStrings: {
    ...t.schoolStrings,
    privacyPolicy: privacyPolicy |> optionalString,
  },
};

let updateTermsOfUse = (termsOfUse, t) => {
  ...t,
  schoolStrings: {
    ...t.schoolStrings,
    termsOfUse: termsOfUse |> optionalString,
  },
};

let updateAddress = (address, t) => {
  ...t,
  schoolStrings: {
    ...t.schoolStrings,
    address: address |> optionalString,
  },
};

let updateEmailAddress = (emailAddress, t) => {
  ...t,
  schoolStrings: {
    ...t.schoolStrings,
    emailAddress: emailAddress |> optionalString,
  },
};

let decodeFile = json =>
  Json.Decode.{
    url: json |> field("url", string),
    filename: json |> field("filename", string),
  };

let decodeImages = json =>
  Json.Decode.{
    logoOnLightBg:
      json
      |> field("logoOnLightBg", nullable(decodeFile))
      |> Js.Null.toOption,
    logoOnDarkBg:
      json |> field("logoOnDarkBg", nullable(decodeFile)) |> Js.Null.toOption,
    icon: json |> field("icon", decodeFile),
  };

let updateImages = (json, t) => {...t, schoolImages: json |> decodeImages};

let decodeStrings = json =>
  Json.Decode.{
    address: json |> field("address", nullable(string)) |> Js.Null.toOption,
    emailAddress:
      json |> field("emailAddress", nullable(string)) |> Js.Null.toOption,
    privacyPolicy:
      json |> field("privacyPolicy", nullable(string)) |> Js.Null.toOption,
    termsOfUse:
      json |> field("termsOfUse", nullable(string)) |> Js.Null.toOption,
  };

let decodeLink = json => {
  let (kind, id, url) =
    Json.Decode.(
      field("kind", string, json),
      field("id", string, json),
      field("url", string, json),
    );

  let title =
    switch (kind) {
    | "header"
    | "footer" => Json.Decode.(field("title", string, json))
    | _ => ""
    };

  switch (kind) {
  | "header" => HeaderLink(id, title, url)
  | "footer" => FooterLink(id, title, url)
  | "social" => SocialLink(id, url)
  | unknownKind => raise(UnknownKindOfLink(unknownKind))
  };
};

let decode = json =>
  Json.Decode.{
    schoolStrings: json |> field("strings", decodeStrings),
    schoolImages: json |> field("images", decodeImages),
    links: json |> field("links", list(decodeLink)),
  };
