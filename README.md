# translator
Translator Notes
version  0.24
Cuga Rajal, February 4, 2018

This is a free language translator by Cuga Rajal and Xija Anzu.
Compatible with Opensim and Second Life.

Get the latest version of the script from: https://github.com/cuga-rajal

In Second Life you can get a Translator at the Burn2 region:
  http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25

How to use:

1) Click the HUD to open the menu. The menu can be used to change
source language, target language, or to enable/disable translation. 

2) It assumes the owner of the HUD speaks a different language than
those in local chat. The HUD owner can select the source (owner's)
language and target (local chat) language.

3) Everyone wearing the HUD in proximity should use the same target
language for local chat. Otherwise, you may get duplication of
translated phrases in  local chat. If two people want to chat in 
languages that are different from local chat, it is best to take that
to private IM to avoid unnecessary translations sent to all nearby.

4) When the HUD owner types in local chat, their chat message is sent
for translation from the source language to the target language.
Translated phrases are sent to local chat with llSay, so everyone in
chat range can see it. To reduce chat clutter, if the translated phrase
is the same as the original, it will not be sent to local chat. This can
happen if the HUD owner is already speaking in the target language, or
if the translation service doesn't recognize the language.

5) When others speak in local chat (not the HUD owner) the phrases are
sent for translation in the reverse direction. Chat messages are
translated from the target language to the source language. The
translated phrase is then sent only to the HUD owner's local chat with
llOwnerSay(), so only the HUD owner sees it. If the translated phrase is
the same as the original, it will not be sent to local chat.

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
