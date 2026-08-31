# scratch-template

This repo contains everything you need to get started making a scratch bot for
RLBot v5 with [bob](https://github.com/swz-git/bob)!

## Bob

The template uses a custom `[settings.environment]` table in `bot.toml`:

```toml
[settings.environment]
RLBOT_SCRATCH_SB3_PATH = "project.sb3"
```

`RLBOT_SCRATCH_SB3_PATH` is used by the Scratch bridge to determine which .sb3
project to load.

### Building

- Install [bob](https://github.com/swz-git/bob)
- Install Docker
- Run `<path to bob.exe> build bob.toml`

## Running in "dev-mode"

1. Add the bot.toml file to your RLBot GUI using the `Add/Remove` button
1. Run the bridge binary with the `RLBOT_AGENT_ID` env var.
   The value of `RLBOT_AGENT_ID` should match the one in your bot.toml
   - `RLBOT_AGENT_ID=YOURAGENTID ./rlbot-scratch-bridge` on linux,
   - `set RLBOT_AGENT_ID=YOURAGENTID && .\rlbot-scratch-bridge.exe` on windows
1. Open `project.sb3` in the turbowarp editor
1. Start a match with the bot and **make sure you've disabled autostart for your 
   bot!**
1. Press the green flag

## Running using autostart

1. Add the bot.toml file to your RLBot GUI using the `Add/Remove` button
1. Start a match with the bot, and it should run headless

## Bridge notes

The bridge binary supports a couple of CLI flags, such as `--packetrate`. To
see all of the available flags, run the binary with the `--help` flag.