// Open Translate v.0.26 - Feb 24 2018
// by Xiija Anzu and Cuga Rajal
//
// Put this script in a HUD and wear it. Click the HUD to open the configuration dialog and set language choices.
// This translator assumes the HUD owner speaks a different language than the local chat.
// More information at https://github.com/cuga-rajal/translator
//
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License.
// To view a copy of the license, visit:
//  https://creativecommons.org/licenses/by-nc-sa/3.0/

string version = "0.26";
key  XMLRequest;
string sourceLang = "es"; // language of the HUD owner, can be changed from setup dialog
string targetLang = "en"; // common language in local chat, can be changed from setup dialog
string msg = "a bunny";
string url2;
integer listenHandle;
integer listenHandle2;
integer hideChan = -667;
integer isHidden;
string owner;
string spkrname;
integer chan;
list gLstMnu;
string txt;
key id;
integer handle;
integer ttlPG;
integer currPG = 0;
integer i;
string langselect = "";
integer active = 1;
string SLslurl = "http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25";
 

list langs = 
[
"Arabic",       "ar", 
"Chinese",      "zh",
"Chinese TW",   "zh-TW",
"Danish",        "da",
"Dutch",        "nl",
"English",      "en",
"French",       "fr",
"German",       "de",
"Hungarian",	"hu",
"Italian",      "it",
"Japanese",     "ja",
"Korean",       "ko",
"Polish",		"pl",
"Portuguese",   "pt",
"Russian",      "ru",
"Spanish",      "es",
"Turkish",		"tr",
"Ukranian",		"uk"
];

list uDlgBtnLst( integer vIdxPag ) {
    gLstMnu = llList2ListStrided(langs, 0, -1, 2);;
    integer vIntTtl = -~((~(integer)([] != gLstMnu)) / 9);      //-- Total possible pages
    integer vIdxBgn = vIdxPag * 9;
    string backbut;
    if(vIdxPag==0) { backbut=" "; } else { backbut = "<<"; }
    string fwdbut;
    if(vIdxPag==vIntTtl) { fwdbut=" "; } else { fwdbut = ">>"; }
    list vLstRtn = llList2List( gLstMnu, vIdxBgn, vIdxBgn + 8 ) + backbut + "Close" + fwdbut;
    return //-- fix the order for [L2R,T2B] and send it out
      llList2List( vLstRtn, -3, -1 ) + llList2List( vLstRtn, -6, -4 ) +
      llList2List( vLstRtn, -9, -7 ) + llList2List( vLstRtn, -12, -10 );
}    

poll() {
     XMLRequest =
     llHTTPRequest( url2 , [
     //HTTP_USER_AGENT, "XML-Getter/1.0 (Mozilla Compatible)", // HTTP_USER_AGENT not supported in Opensim, uncomment for SL
     HTTP_METHOD, "GET", 
     HTTP_MIMETYPE, "text/html;charset-utf8", 
     HTTP_BODY_MAXLENGTH,16384,
     HTTP_PRAGMA_NO_CACHE,TRUE], "");
}

default {

    state_entry() {
    
        string server = llGetEnv("simulator_hostname");
        list serverParsed = llParseString2List(server,["."],[]);
        string grid = llList2String(serverParsed, llGetListLength(serverParsed) - 2);
        string detectedLang = llGetSubString(llGetAgentLanguage(llGetOwner()),0,1);
    
        chan = 0x80000000 | (integer)("0x"+(string)llGetOwner());    // unique channel based on owners UUID   
        listenHandle = llListen(0, "","", "");
        listenHandle2 = llListen(hideChan, "",llGetOwner(), "");
        owner = llGetDisplayName(llGetOwner());
        string intromessage = "Resetting...\nOpen Translator " + version + " by Cuga Rajal and Xiija Anzu";
        if(grid == "lindenlab") { intromessage += "\nGet your free copy in SL at " + SLslurl; }
        intromessage += "\nInstructions and source code at https://github.com/cuga-rajal/translator";
        if(llListFindList( langs, [detectedLang] )!=-1) {
            sourceLang = detectedLang;
            intromessage += "\nSource language set to '" + 
            llList2String(langs,llListFindList(langs,(list)detectedLang)-1) +
            "' from viewer settings.";
        }
        else { intromessage += "\nLanguage '" + detectedLang + "' not found, please select source language manually."; }
        llOwnerSay(intromessage);
    }
    
    touch_start(integer total_number) {   
        id = llDetectedKey(0);
        txt = "Current settings:\n My Language: " + llList2String(langs,llListFindList(langs,(list)sourceLang)-1) + 
          "\n Translating To: " + llList2String(langs,llListFindList(langs,(list)targetLang)-1) +
          "\n\nChange:";
        string togglebutton;
        if(active==1) { togglebutton = "Disable"; } else { togglebutton = "Enable"; }
        list buttonlist = [togglebutton,"Get Gesture","Instructions","My Language","Translating To","Close"];
        buttonlist = llList2List( buttonlist, -3, -1 ) + llList2List( buttonlist, -6, -4 ) +
        llList2List( buttonlist, -9, -7 ) + llList2List( buttonlist, -12, -10 );
        llDialog(id, txt, buttonlist, chan );
        handle = llListen(chan,"","","");
        llListenControl(handle, TRUE); 
        llSetTimerEvent(20);
    }   

    http_response(key k,integer status, list meta, string body) { 
        if(k ==  XMLRequest) {
            if(status == 503) {
                url2 = "http://ip-api.com/json";
                isHidden=2;
                poll();
                return;
            }
            if(isHidden == 2) {
                string ip = llJsonGetValue( body, ["query"]);
                llOwnerSay("Region IP " + ip + " is blocked by translation service.");
                return;
            }
            string returnstring = llUnescapeURL( body );
            string translatedmessage = "";
            list phraselist = llParseString2List(returnstring,[ "[", "]" ], [ "],[" ]);
            for(i=0; i<llGetListLength(phraselist); i++) {
                if(i %2==1) { jump next; } // Why this is required? Bug fix? 
                list thisphrase = llParseString2List(llList2String(phraselist,i),[ "\"" ], [ "\",\"" ]);
                translatedmessage += llList2String(thisphrase,0);
                @next;
            }
            if(msg == translatedmessage) { jump skipme; }
            if((owner==spkrname) || (isHidden==1)) {
               llSay(0,owner + ": "  + translatedmessage);
            } else {
               llOwnerSay(spkrname + ": "  + translatedmessage);
            }
            @skipme;
        }
    }
    
    listen( integer vIntChn, string vStrNom, key vKeySpk, string vStrMsg ) {
        if ((vIntChn == 0 ) || (vIntChn == hideChan)) { // hideChan is already filtered to hear only owner   
            spkrname = llGetDisplayName(vKeySpk);
            if(spkrname=="") { jump skiptrans; }
            if(vIntChn==0) { isHidden=0; }
            else { isHidden=1; }
            msg =  vStrMsg;
            url2 = "http://translate.googleapis.com/translate_a/single?client=gtx&sl=&dt=t&ie=UTF-8&oe=UTF-8";
            if((vIntChn == hideChan) || (llGetDisplayName(llGetOwner())==spkrname)) {
                url2 += "&sl=" + sourceLang + "&tl=" + targetLang;
            } else {
                url2 += "&sl=" + targetLang + "&tl=" + sourceLang; 
            }
            url2 += "&q=" + llEscapeURL(msg);
            poll();
            @skiptrans;
            return;
        }
        if(vStrMsg == "My Language") {
            langselect = "source";
            txt = "Current settings:\n HUD owner language (source): " +
               llList2String(langs,llListFindList(langs,(list)sourceLang)-1) + 
               "\n Local chat language (target): " + llList2String(langs,llListFindList(langs,(list)targetLang)-1) +
               "\n\nPlease select source language:";
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == "Translating To") {
            langselect = "target";
            txt = "Current settings:\n HUD owner language (source): " +
               llList2String(langs,llListFindList(langs,(list)sourceLang)-1) + 
               "\n Local chat language (target): " + llList2String(langs,llListFindList(langs,(list)targetLang)-1) +
               "\n\nPlease select target language:";
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == ">>") {
            ++currPG;
            if(currPG > ttlPG) { currPG = 1;}
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == "<<") {
            --currPG;
            if(currPG < 1) { currPG = ttlPG;}
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if (vStrMsg == "Close") {
            llSetTimerEvent(0.5);
        } else if (vStrMsg == " ") {
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if (vStrMsg == "Disable") {
            active=0;
            llListenControl(listenHandle, FALSE); 
            llListenControl(listenHandle2, FALSE); 
            llSetLinkPrimitiveParamsFast(0, [ PRIM_COLOR, ALL_SIDES, <0.4, 0.4, 0.4>, 1.0 ]);
            llOwnerSay("Translator has been disabled");
        } else if (vStrMsg == "Get Gesture") {
            llGiveInventory( llGetOwner(), llGetInventoryName(INVENTORY_GESTURE, 0)  );
            llOwnerSay("\nTo use: activate the gesture, then type ... // .. and your message," +
                      "\nExample: // hello furries " );
        } else if (vStrMsg == "Instructions") {
            llGiveInventory( llGetOwner(), llGetInventoryName(INVENTORY_NOTECARD, 0)  );
        } else if (vStrMsg == "Enable") {
            active=1;
            llListenControl(listenHandle, TRUE);
            llListenControl(listenHandle2, TRUE); 
            llSetLinkPrimitiveParamsFast(0, [ PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0 ]);
            llOwnerSay("Translator has been enabled");
        } else {
            if(langselect=="source") {
                sourceLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)+1);
                llOwnerSay("Source language set to " + vStrMsg);
            } else if(langselect=="target") {    
                targetLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)+1);
                llOwnerSay("Target language set to " + vStrMsg);
            }      
        }
    }
    
    timer() {
        llListenControl(handle, FALSE);
        llSetTimerEvent(0);
    }
    
    changed(integer change) {
        if (change & (CHANGED_OWNER) ) {
            llResetScript();
        }
    }
    
}
