import { Socket } from "phoenix";

const authSocket = new Socket("/auth_socket", {
  params: { token: window.authToken },
});

authSocket.onOpen(() => console.log("authSocket connected"));
authSocket.connect();

authSocket.channel("user:1").join();

const recurringChannel = authSocket.channel("recurring");

recurringChannel.on("new_token", (payload) => {
  console.log("received new auth token", payload);
});
recurringChannel.join();

const dupeChannel = authSocket.channel("dupe");
dupeChannel.on("number", (payload) => {
  console.log("new number received", payload);
});
dupeChannel.join();
