# translator
Translator Notes
version  0.38, June 29, 2019

This is a free language translator by Cuga Rajal and Xiija Anzu.
Compatible with Opensim and Second Life.

Get the latest version of the script from: https://github.com/cuga-rajal

In Second Life you can get a Translator at the Burn2 region:
  http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25

This work is licensed under Creative Commons BY-NC-SA 3.0:
  https://creativecommons.org/licenses/by-nc-sa/3.0/
  
**How to build from source:**

You can import the .oxp object into your world and then take it into inventory,
or build a new one using the files provided.

To build your own:

1) Save each of the dialog files ("dialogs_ar" etc.) as separate notecards

2) Save a copy of these instructions in a notecard named "Translator
Instructions". You can omit "How to build from source" section.

3) Save the main script "translate.lsl" as a script

4) Create a new gesture, using the name "Translate Helper". Set Trigger to "//"
and set Replace With to "/-667" (without quotes). Save this to your inventory.

5) Rez a cylinder .05 x .05 x .02. Place all the notecards, script and gesture
described above into the contents.

6) Name the cylinder "Translator" and take it into your inventory

7) Wear the object as a HUD (Right click -> Attach to HUD -> Center) Edit the
object and set the rotation to <0, 90, 270>.

8) The HUD has no buttons. Clicking it opens a dialog box. All controls are made
through the dialogs. You can decorate it and resize/reposition however you like.


**How to use:**

1) Wear the Translator as a HUD. The Translator uses dialogs for all the
controls. Click the Translator HUD object on the screen to open the dialog. The
dialog can be used to change the source language, target language, or to
enable/disable translation. It can also give the gesture object (see below) or
to get these instructions.

2) The Translator is meant to be used when the HUD owner speaks a different
language than local chat. The "source language" should be set to the HUD owner's
language, and "target language" should be set to the local chat language.

The first time you wear the HUD, it will try to detect your language from the
viewer preferences to use as the source language. If it can not detect the
viewer settings, it will default to English. Some versions of Singularity do not
support language detection. In this case, the source language can be set
manually.

3) For best results, everyone wearing the HUD in proximity should use the same
target language for local chat. Otherwise you may get duplication of translated
phrases in local chat.

4) When the HUD owner types in local chat, their chat message is sent for
translation from the source language to the target language. The translated
phrase is then sent to local chat with llSay. Everyone in chat range can see the
translated phrase after the original phrase.

To reduce chat clutter, if the translated phrase is the same as the original, it
will not be sent to local chat to avoid duplication.. This can happen if the HUD
owner is already speaking in the target language, or if the translation service
doesn't recognize the words.

5) When other people speak in local chat, the phrases are sent for translation
in the reverse direction. Chat messages are translated from the target language
to the source language. The translated phrase is sent only to the HUD owner's
local chat with llOwnerSay(). If the translated phrase is the same as the
original, it will not be sent to local chat to avoid duplication.

6) There is an optional Gesture that can be used with the translator to further
reduce chat clutter. The Gesture gives you the option to say only your
translated phrase to local chat without including the original native phrase.
You can get a copy of the gesture by selecting the dialog button "Get Gesture"
which will copy it to your inventory.

To use the gesture, first make it active, then type "// " and then your phrase. 
For example, "// Hello furries"


**Suggestions for in-world distribution:**

If you create your own translator object from this script, or import the .oxp
linkset file from github, we recommend making the object no-modify so that
someone doesn't alter the script contents in a prim with your name on it.

In SL, the translator object is no-transfer. You can get your free copy by
visiting Burn2 Region anytime. 

**Issues:**

- There is a 16kb size limit per translation. Anything over that is truncated.

- There have been cases where excessive use of the translators by multiple
people can cause Google's translation service to block the service for up to 2
hours. If this happens, the Translator will print a message to local chat with
an alert about the service being unavailable. 

We are exploring other translation services that don't have this issue.

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
