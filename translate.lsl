// Open Translate v.0.33 - Sept 16, 2018
// by Xiija Anzu and Cuga Rajal
//
// Put this script in a HUD and wear it. Click the HUD to open the configuration dialog and set language choices.
// This translator assumes the HUD owner speaks a different language than the local chat.
// More information at https://github.com/cuga-rajal/translator
//
// This work is licensed under Creative Commons BY-NC-SA 3.0:
//  https://creativecommons.org/licenses/by-nc-sa/3.0/

string version = "0.33"; 
key XMLRequest;
string sourceLang = "es"; // language of the HUD owner, can be changed from setup dialog
string targetLang = "en"; // common language in local chat, can be changed from setup dialog
string msg = "a bunny";
string url2;
integer listenHandle = 0;
integer listenHandle2 = 0;
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
integer vIntTtl;
integer i;
string langselect = "";
integer active = 1;
integer iLine;
key kQuery;
string notecard_name;
integer manual_reset = FALSE;
integer is_busy = TRUE;
string SLslurl = "http://maps.secondlife.com/secondlife/Burning%20Man-%20Deep%20Hole/232/88/25";
string dl_01;
string dl_02;
string dl_03;
string dl_04;
string dl_05;
string dl_06;
string dl_07;
string dl_08;
string dl_09;
string dl_10;
string dl_11;
string dl_12;
string dl_13;
string dl_14;
string dl_15;
string dl_16;
string dl_17;
string dl_18;
string dl_19;
string dl_20;


list dlog_list = [ "dl_01", "dl_02", "dl_03", "dl_04", "dl_05", "dl_06", "dl_07", "dl_08", "dl_09", "dl_10", 
                   "dl_11", "dl_12", "dl_13", "dl_14", "dl_15", "dl_16", "dl_17", "dl_18", "dl_19", "dl_20" ];
string dlitem = "";

list langs = 
[
"Arabic",       "ar",        "عربى",            "",
"Chinese",      "zh",        "简体 中文",        "",
"Chinese TW",   "zh-TW",    "繁體 中文 ",        "",
"Danish",       "da",        "Dansk",        "",
"Dutch",        "nl",        "Nederlands",    "",
"English",      "en",        "English",        "",
"French",       "fr",        "Français",        "",
"German",       "de",        "Deutsch",        "",
"Finnish",        "fi",        "Suomi",         "",
"Hungarian",    "hu",        "Magyar",        "",
"Italian",      "it",        "Italiano",        "",
"Japanese",     "ja",        "日本語",            "",
"Korean",       "ko",        "한국어",            "",
"Polish",        "pl",        "Polski",        "",
"Portuguese",   "pt",        "Português",    "",
"Russian",      "ru",        "Pусский",        "",
"Spanish",      "es",        "Español",        "",
"Swedish",        "sv",         "Svenska",         "",
"Turkish",        "tr",        "Türkçe",        "",
"Ukranian",        "uk",         "Українська",     ""
];

list uDlgBtnLst( integer vIdxPag ) {
    if(langselect=="source") { gLstMnu = llList2ListStrided(llDeleteSubList(langs, 0, 1), 0, -1, 4); }
    else { gLstMnu = llList2ListStrided(llDeleteSubList(langs, 0, 2), 0, -1, 4); }
    vIntTtl = llCeil(llGetListLength(gLstMnu) / 9);      //-- Total possible pages
    integer vIdxBgn = vIdxPag * 9;
    string backbut;
    if(vIdxPag==0) { backbut=" "; } else { backbut = "<<"; }
    string fwdbut;
    if(vIdxPag==vIntTtl) { fwdbut=" "; } else { fwdbut = ">>"; }
    list vLstRtn = llList2List( gLstMnu, vIdxBgn, vIdxBgn + 8 ) + backbut + dl_17 + fwdbut;
    return //-- fix the order for [L2R,T2B] and send it out
      llList2List( vLstRtn, -3, -1 ) + llList2List( vLstRtn, -6, -4 ) +
      llList2List( vLstRtn, -9, -7 ) + llList2List( vLstRtn, -12, -10 );
}    

poll() {
     XMLRequest = llHTTPRequest( url2 , [
     //HTTP_USER_AGENT, "XML-Getter/1.0 (Mozilla Compatible)", // HTTP_USER_AGENT not supported in Opensim, uncomment for SL
     HTTP_METHOD, "GET", 
     HTTP_MIMETYPE, "text/html;charset-utf8", 
     HTTP_BODY_MAXLENGTH,16384,
     HTTP_PRAGMA_NO_CACHE,TRUE], "");
}

string str_replace(string src, string from, string to) {
    integer len = (~-(llStringLength(from)));
    if(~len) {
        string  buffer = src;
        integer b_pos = -1;
        integer to_len = (~-(llStringLength(to)));
        @loop;//instead of a while loop, saves 5 bytes (and runs faster).
        integer to_pos = ~llSubStringIndex(buffer, from);
        if(to_pos) {
            b_pos -= to_pos;
            src = llInsertString(llDeleteSubString(src, b_pos, b_pos + len), b_pos, to);
            buffer = llGetSubString(src, (-~(b_pos += to_len)), 0x8000);
            jump loop;
        }
    }
    return src;
}

translateMenus(string sourceLang) {
    is_busy = TRUE;
    llOwnerSay("Resetting...");
    notecard_name = "dialogs_" + sourceLang;
    integer nFound=FALSE;
    for (i=0; i<llGetInventoryNumber(INVENTORY_NOTECARD);i++) {
        if(notecard_name==llGetInventoryName(INVENTORY_NOTECARD, i)) { nFound=TRUE; }
    }
    if(! nFound) { llOwnerSay("Notecard '" + notecard_name + "' not found"); jump end; }
    iLine = 0;
    kQuery = llGetNotecardLine(notecard_name, iLine);
    @end;
}

setVar(string dlog, string qval) {
    if(llSubStringIndex(dlog, "lang_") == 0) {
        integer listpos = llListFindList(langs,(list)llGetSubString(dlog, 5, -1));
        listpos += 2;
        langs = llListReplaceList(langs, (list)qval, listpos, listpos);
    }
    else if(dlog=="dl_01") { dl_01 = str_replace(qval, "XXX", version); }
    else if(dlog=="dl_02") { dl_02 = str_replace(qval, "XXX", SLslurl); }
    else if(dlog=="dl_03") { dl_03 = str_replace(qval, "XXX", "https://github.com/cuga-rajal/translator"); }
    else if(dlog=="dl_04") { dl_04 = qval; }
    else if(dlog=="dl_05") { dl_05 = qval; }
    else if(dlog=="dl_06") { dl_06 = qval; }
    else if(dlog=="dl_07") { dl_07 = qval; }
    else if(dlog=="dl_08") { dl_08 = qval; }
    else if(dlog=="dl_09") { dl_09 = qval; }
    else if(dlog=="dl_10") { dl_10 = qval; }
    else if(dlog=="dl_11") { dl_11 = qval; }
    else if(dlog=="dl_12") { dl_12 = qval; }
    else if(dlog=="dl_13") { dl_13 = qval; }
    else if(dlog=="dl_14") { dl_14 = qval; }
    else if(dlog=="dl_15") { dl_15 = qval; }
    else if(dlog=="dl_16") { dl_16 = qval; }
    else if(dlog=="dl_17") { dl_17 = qval; }
    else if(dlog=="dl_18") { dl_18 = qval; }
    else if(dlog=="dl_19") { dl_19 = qval; }
    else if(dlog=="dl_20") { dl_20 = qval; }
}

finish() {
        llOwnerSay("Finishing..");
        chan = 0x80000000 | (integer)("0x"+(string)llGetOwner());    // unique channel based on owners UUID   
        if(listenHandle==0) { listenHandle = llListen(0, "","", ""); }
        if(listenHandle2==0) { listenHandle2 = llListen(hideChan, "",llGetOwner(), ""); }
        owner = llGetDisplayName(llGetOwner());
        
        //string server = llGetEnv("simulator_hostname");
        //list serverParsed = llParseString2List(server,["."],[]);
        //string grid = llList2String(serverParsed, llGetListLength(serverParsed) - 2);
        string intromessage = "\n" + dl_01;
        //if(grid == "lindenlab") { intromessage += "\n" + dl_02; }
        intromessage += "\n" + dl_03;
        if(llListFindList( langs, [sourceLang] )!=-1) {
            if(manual_reset) {
                intromessage += "\n" + str_replace(dl_04, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2));
            } else {
                intromessage += "\n" + str_replace(dl_06, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2));
            }
        
        } else {
            intromessage += "\nLanguage '" + llGetAgentLanguage(llGetOwner()) + "' not found, please select your language manually.";
        }
        llOwnerSay(intromessage);
        manual_reset = TRUE;
        is_busy = FALSE;
}

default {

    state_entry() {
        string dl_01 = "Open Translator version " + version + " by Cuga Rajal and Xiija Anzu";
        string dl_02 = "Get your free copy in SL at " + SLslurl;
        string dl_03 = "Instructions and source code at https://github.com/cuga-rajal/translator";
        string dl_04 = "My Language: English (en)";
        string dl_05 = "Local Chat Language: English (en)";

        string detectedLang = llGetSubString(llGetAgentLanguage(llGetOwner()),0,1);
        if(detectedLang=="") {
            sourceLang = "en";
            manual_reset = TRUE;
        } else if(llListFindList( langs, [llGetAgentLanguage(llGetOwner())] )!=-1) {
            sourceLang = llGetAgentLanguage(llGetOwner());
        } else if(llListFindList( langs, [detectedLang] )!=-1) {
            sourceLang = detectedLang;
        }
        if(llListFindList( langs, [sourceLang] )!=-1) {
           translateMenus(sourceLang);
        } else {
            finish();
        }
        
 
    }
    
    touch_start(integer total_number) {
        if(is_busy) { return; }
        id = llDetectedKey(0);
        txt = dl_18 + "\n " + str_replace(dl_04, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2)) +
        "\n " + str_replace(dl_05, "XXX", llList2String(langs,llListFindList(langs,(list)targetLang)+2)) + "\n\n" + dl_12;
        string togglebutton;
        if(active==1) { togglebutton = dl_13; } else { togglebutton = dl_14; }
        list buttonlist = [togglebutton,dl_15,dl_16,dl_10,dl_11,dl_17];
        buttonlist = llList2List( buttonlist, -3, -1 ) + llList2List( buttonlist, -6, -4 ) +
        llList2List( buttonlist, -9, -7 ) + llList2List( buttonlist, -12, -10 );
        llDialog(id, txt, buttonlist, chan );
        handle = llListen(chan,"","","");
        llListenControl(handle, TRUE); 
        llSetTimerEvent(20);
    }   
    
    dataserver(key query_id, string data) {
        if (query_id == kQuery) {
            if (data != EOF)  {
                if(llStringTrim(data, STRING_TRIM)=="") { jump break; }
                list tmp = llParseString2List(data, ["="], []);
                string dlog = llStringTrim(llList2String(tmp,0), STRING_TRIM);
                string qval = llStringTrim(llList2String(tmp,1), STRING_TRIM);
                setVar(dlog, qval);
                @break;
                ++iLine;
                kQuery = llGetNotecardLine(notecard_name, iLine);
            } else {
                finish();
            }
        }
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
                llOwnerSay(str_replace(dl_07, "XXX", ip));
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
            if(spkrname=="") { jump skiptrans; } // Don't translate other translators!
            if(vIntChn==0) { isHidden=0; }  // tells callback if the phrase came from gesture
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
        if(vStrMsg == dl_10) {
            langselect = "source";
            txt = dl_18 + "\n " + 
               str_replace(dl_04, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2)) +
               "\n " + str_replace(dl_05, "XXX", llList2String(langs,llListFindList(langs,(list)targetLang)+2)) +
               "\n\n" + str_replace(dl_04, "XXX", "");
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == dl_11) {
            langselect = "target";
            txt = dl_18 + "\n " + 
               str_replace(dl_04, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2)) +
               "\n " + str_replace(dl_05, "XXX", llList2String(langs,llListFindList(langs,(list)targetLang)+2)) +
               "\n\n" + str_replace(dl_05, "XXX", "");
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == ">>") {
            ++currPG;
            if(currPG > vIntTtl) { currPG = 0;}
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if(vStrMsg == "<<") {
            --currPG;
            if(currPG < 0) { currPG = vIntTtl;}
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if (vStrMsg == dl_17) { // Close
            llSetTimerEvent(0.5);
        } else if (vStrMsg == " ") {
            llDialog(id, txt, uDlgBtnLst(currPG), chan );
            llSetTimerEvent(20); 
        } else if (vStrMsg == dl_13) {  // Disable
            active=0;
            llListenControl(listenHandle, FALSE); 
            llListenControl(listenHandle2, FALSE); 
            llSetLinkPrimitiveParamsFast(0, [ PRIM_COLOR, ALL_SIDES, <0.4, 0.4, 0.4>, 1.0 ]);
            llOwnerSay(dl_08);
        } else if (vStrMsg == dl_15) { // Get Gesture
            llGiveInventory( llGetOwner(), llGetInventoryName(INVENTORY_GESTURE, 0)  );
            llOwnerSay("\n" + dl_19 + "\n" + dl_20); // To use, type.. Example..
        } else if (vStrMsg == dl_16) { // Instructions
            string helpurl = "";
            if(sourceLang=="en") {
                helpurl = "https://github.com/cuga-rajal/translator";
            } else {
                helpurl = "https://translate.google.com/translate?act=url&hl=en&ie=UTF8&sl=en&tl=" + sourceLang + "&u=https://github.com/cuga-rajal/translator";
            }
            llLoadURL( llGetOwner(), "", helpurl );
            //notecard_name = "instructions_" + sourceLang;
            //integer nFound2=FALSE;
            //for (i=0; i<llGetInventoryNumber(INVENTORY_NOTECARD);i++) {
            //    if(notecard_name==llGetInventoryName(INVENTORY_NOTECARD, i)) { nFound2=TRUE; }
            //}
            //if(! nFound2) { notecard_name = "instructions_en"; }
            //llGiveInventory( llGetOwner(), notecard_name);
        } else if (vStrMsg == dl_14) {
            active=1;
            llListenControl(listenHandle, TRUE);
            llListenControl(listenHandle2, TRUE); 
            llSetLinkPrimitiveParamsFast(0, [ PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0 ]);
            llOwnerSay(dl_09);
        } else {
            if(langselect=="source") {
                if(llStringLength(llList2String(langs,llListFindList(langs,(list)vStrMsg)-1))<3) {
                    sourceLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)-1);
                } else {
                    sourceLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)+1);
                }
                //llOwnerSay(str_replace(dl_04, "XXX", llList2String(langs,llListFindList(langs,(list)sourceLang)+2)));
                translateMenus(sourceLang);
            } else if(langselect=="target") {
                if(llStringLength(llList2String(langs,llListFindList(langs,(list)vStrMsg)-2))<3) {
                    targetLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)-2);
                } else {
                    targetLang = llList2String(langs,llListFindList(langs,(list)vStrMsg)+1);
                }
                llOwnerSay(str_replace(dl_05, "XXX", llList2String(langs,llListFindList(langs,(list)targetLang)+2)));
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
