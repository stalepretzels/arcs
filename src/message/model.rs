use serde::{Deserialize, Serialize};
use std::str::FromStr;

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(untagged)]
enum MessageTypes {
  MessageSent(MessageSent),
  RetrieveMessages(RetrieveMessages)
}

#[derive(Serialize, Deserialize, Debug)]
struct MessageSent {
    msg: String,
    user: String
}
#[derive(Serialize, Deserialize, Debug)]
struct RetrieveMessages {
    msgs: VecString
}
