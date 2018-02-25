# translator
Translator Notes
version  0.26
Cuga Rajal, February 24, 2018

This is a free language translator by Cuga Rajal and Xiija Anzu.
Compatible with Opensim and Second Life.

Get the latest version of the script from: https://github.com/cuga-rajal

In Second Life you can get a Translator at the Burn2 region:
  http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25

This work is licensed under the Creative Commons BY-NC-SA 3.0 License.
To view a copy of the license, visit:
  https://creativecommons.org/licenses/by-nc-sa/3.0/


How to use:

1) Wear the Translator as a HUD. Click the Translator to open the dialog. The
dialog can be used to change the source language, target language, or to
enable/disable translation. It can also give the gesture object (see below)
or to get these instructions.

2) The Translator can be used when the HUD owner speaks a different language than
local chat. The "source language" should be set to the HUD owner's language, and
"target language" should be set to the local chat language.

The first time you wear the HUD, it will detect your viewer preference settings and 
configure the source language automatically.

3) For best results, everyone wearing the HUD in proximity should use the same
target language for local chat. Otherwise you may get duplication of translated
phrases in local chat.

4) When the HUD owner types in local chat, their chat message is sent for
translation from the source language to the target language. The translated
phrase is then sent to local chat with llSay, so everyone in chat range can see
it.

To reduce chat clutter, if the translated phrase is the same as the original, it
will not be sent to local chat. This can happen if the HUD owner is already
speaking in the target language, or if the translation service doesn't recognize
the language.

5) When others speak in local chat (not the HUD owner) the phrases are sent for
translation in the reverse direction. Chat messages are translated from the
target language to the source language. The translated phrase is then sent to
the HUD owner's local chat with llOwnerSay(), so only the HUD owner sees it. If
the translated phrase is the same as the original, it will not be sent to local
chat.

6) There is an optional Gesture that can be used with the translator.
Use the dialog button "Get Gesture" to copy it to your inventory.
The Gesture gives you the option to print your translated phrase to local chat
without also printing your original phrase, to further reduce chat clutter.

To use the gesture, first make it active, then type "// " and then your phrase. 
For example, "// Hello furries"

Issues:

- There is a 16kb size limit per translation. Anything over that is truncated.

- Excessive use can trigger Google's bot blockers to block the region's IP
  address for a period. Usually Google restores access in 2 hours.
  In SL, restarting the sim can sometimes fix the issue as this usually
  reassigns the IP address.

  We are exploring other translation services that don't have this issue.
  
- Opensim script engine currently has a bug that breaks llGetEnv() or
  llGetSimulatorHostname. So a section in state_entry() is temporarily
  disabled.
  
Future plans:

- Translated dialogs

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
