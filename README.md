# pomogotchi

***Simple Terminal Pomodoro Timer***

## 🚀 Quick Start

Clone the repository

```bash
git clone https://github.com/newagemob/pomogotchi.git
```

Change directory and make script executable

```bash
cd pomogotchi && chmod +x pomogotchi.sh
```

Run the script
```bash
./pomogotchi.sh
```

### Config and Customization

## Custom Sounds

The best way to add custom sounds is by using [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download the audio from YouTube. 

```bash
yt-dlp --extract-audio --format mp3 "{YouTube URL}"
```

Then move the audio file to the `audio` directory.

```bash
mv "{audio file}" audio/{new sound}.mp3
```

Finally, you'll want to use the `config.sh` script to add the new sound to the list of available sounds.

```bash
./config.sh
```

## TODO
- [ ] Add config script to set timer and break length
- [ ] Add animal emojis to represent timer and break
- [ ] Add emoji selection to config script
- [ ] Add color selection to config script
- [ ] Add more sounds to config script
- [ ] Add logging to keep track of completed pomodoros
