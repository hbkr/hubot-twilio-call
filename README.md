# hubot-twilio-call

A hubot script for calling Twilio API

See [`src/twilio-call.coffee`](src/twilio-call.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-twilio-call --save`

Then add **hubot-twilio-call** to your `external-scripts.json`:

```json
[
  "hubot-twilio-call"
]
```

## Sample Interaction

```
user1> hubot call +8180xxxxxxxx hello
hubot> Calling to +8180xxxxxxxx
```
