# translator
Translator Notes
version  0.33, Sept 16, 2018

This is a free language translator by Cuga Rajal and Xiija Anzu.
Compatible with Opensim and Second Life.

Get the latest version of the script from: https://github.com/cuga-rajal

In Second Life you can get a Translator at the Burn2 region:
  http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25

This work is licensed under Creative Commons BY-NC-SA 3.0:
  https://creativecommons.org/licenses/by-nc-sa/3.0/


How to use:

1) Wear the Translator as a HUD. Click the Translator to open the dialog. The
dialog can be used to change the source language, target language, or to
enable/disable translation. It can also give the gesture object (see below)
or to get these instructions.

2) Use the Translator when the HUD owner speaks a different language than
local chat. The "source language" should be set to the HUD owner's language, and
"target language" should be set to the local chat language.

The first time you wear the HUD, it will try to detect your viewer preferences
configure the source language automatically. If it can not detect the viewer
settings, it will default to English. Some versions of Singularity do not 
support language detection. In this case, the source language can be set
manually.


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

5) When other people speak in local chat, the phrases are sent for translation
in the reverse direction. Chat messages are translated from the target language
to the source language. The translated phrase is then sent to the HUD owner's
local chat with llOwnerSay(), so only the HUD owner sees it. If the translated
phrase is the same as the original, it will not be sent to local chat.

6) There is an optional Gesture that can be used with the translator.
Use the dialog button "Get Gesture" to copy it to your inventory.
The Gesture gives you the option to print your translated phrase to local chat
without also printing your original phrase, to further reduce chat clutter.

To use the gesture, first make it active, then type "// " and then your phrase. 
For example, "// Hello furries"


Suggestions for in-world distribution:

If you create your own translator object from this script, or import the .oxf
linkset file from github, we recommend making the object no-modify so that
someone doesn't alter the script contents in a prim with your name on it.

In SL, the translator object is no-transfer. You can get your free copy by
visiting Burn2 Region anytime. 

Issues:

- There is a 16kb size limit per translation. Anything over that is truncated.

- There have been cases where Google's "bot blockers" have been triggered by the
  use of this Translator, causing the service to be blocked by Google for up to
  2 hours. If this happens during use of the Translator, a message will be sent
  to local chat informing the owner of the service being unavailable. 

  We are exploring other translation services that don't have this issue.

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
