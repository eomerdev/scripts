#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Encode H.265 video file
# Author: eomerdev <eomerdev@gmail.com>

import argparse
import subprocess
import re
import os.path
import magic

defaults = {
   "video_codec": "libx265",
   "audio_codec": "aac",
   "crf": 25,
   "preset": "medium",
   "audio_bitrate": "128k",
   "video_tag": "hvc1",
   "loglevel": "info"
}

def is_time_regex(arg, time=re.compile(r"^[0-9]{2}:[0-9]{2}:[0-9]{2}$")):
    if not time.match(arg):
       raise argparse.ArgumentTypeError("Invalid value. Use hh:mm:ss format.")
    return arg

def is_crf(arg):
   crf = int(arg)
   if crf < 0 or crf > 51:
      raise argparse.ArgumentTypeError("Invalid value. Use a value between 0 and 51.")
   return crf

def parse_args():
   parser = argparse.ArgumentParser(prog = "h265encoder",
                                    description = "A H265/HVEC video encoder")
   parser.add_argument("input", \
                       help = "Input video file to encode")
   parser.add_argument("output", \
                       help = "Output video file encoded")
   parser.add_argument("--time", \
                       type=is_time_regex, \
                       nargs = 2, \
                       default = [None, None], \
                       help = "Time interval with START and DURATION")
   parser.add_argument("--crf", \
                       type = is_crf, \
                       default = defaults["crf"], \
                       help = "Quality 0-51 (Default {})".format(defaults["crf"]))
   parser.add_argument("--audio-bitrate", \
                       default = defaults["audio_bitrate"], \
                       dest = "audio_bitrate", \
                       help = "Audio bitrate (Default {})".format(defaults["audio_bitrate"]))
   parser.add_argument("--preset", \
                       default = defaults["preset"], \
                       choices = ["ultrafast" ,"superfast", "veryfast", \
                                  "faster", "fast", "medium", "slow", \
                                  "slower", "veryslow", "placebo"], \
                       help = "Compression efficiency. (Default {})".format(defaults["preset"]))

   return vars(parser.parse_args())

def make_command(args):
   command = ["ffmpeg"]

   command.extend(["-loglevel", defaults["loglevel"]])

   if args["time"][0]:
      command.extend(["-ss", args["time"][0]])

   command.extend(["-i", args["input"]])

   if args["time"][1]:
      command.extend(["-t", args["time"][1]])

   command.extend(["-c:v", defaults["video_codec"]]);
   command.extend(["-c:a", defaults["audio_codec"]]);
   command.extend(["-crf", str(args["crf"])]);
   command.extend(["-preset", args["preset"]]);
   command.extend(["-b:a", args["audio_bitrate"]]);
   command.extend(["-tag:v", defaults["video_tag"]]);
   command.append(args["output"])

   return command

def verify_command(command):
   inputfile = command[command.index("-i") + 1]
   outputfile = command[-1]

   if not os.path.isfile(inputfile):
      print("{} not found".format(inputfile))
      return False

   if not magic.from_file(inputfile, mime=True).split("/")[0] == "video":
      print("{} is not a video file".format(inputfile))
      return False

   if os.path.exists(outputfile):
      print("{} file already exists".format(outputfile))
      return False

   return True

def main():
   command = make_command(parse_args())
   if not verify_command(command):
      exit(1)

   subprocess.run(command)
   print("Encoding process COMPLETED")


if __name__ == '__main__': main()
