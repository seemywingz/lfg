LFG
--------------------------
World of Warcraft Chat Addon


## Tired of watching chat to find a group? 😭
## Your problems have been solved! 😮
**LFG** watches chat for you...  
Just tell **LFG** what criteria to watch for e.g. `LFG DPS RFC`  
and **LFG** will allert you when there is a match!  
**LFG** works for more than just goup searches...  
Tell **LFG** to watch for `WTB` or `WTS` chat messages too, the possibilities are literally endless ∞

### Options:
Enable/Disable  
Channel Selection  
Dynamic Set of Search Criteria  
Auto Whisper on Match  
Custom Whisper Messages  
Auto Invite on Match  

### Commands  
Help:                    /lfg help  
Config:                  /lfg config  
Toggle Enabled/Disabled: /lfg  

### Example Configuration
**LFG Enabled:** Yes  
**Listen to Channel:**  
1. No  
2. No  
3. No  
4. Yes (WoW default LFG channel)  

**Match Criteria:** +/-  
1. lfm  
2. dps  
3. uld  

**Auto Response:**  
Whisper: yes "lvl 45 lock, I'm Down!"  
Invite: No  

### Example Watching Trade for Specific Items Configuration
**LFG Enabled:** Yes  
**Listen to Channel:**  
1. No  
2. Yes (WoW default Trade channel)   
3. No  
4. No

**Match Criteria:** +/-  
1. wts  
2. silk cloth

**Auto Response:**  
Whisper: yes "I'm looking to buy some silk!"  
Invite: No  

###### you can watch multiple channels for different things... like /2 and /4 for "LFG WTS"
###### but I reccomend keeping it simple at first 😅
&nbsp;  
&nbsp;  

### A Bit of an Explanation
Lets say this is our criteria  
**Match Criteria:** +/-  
1. lfm lf1m  
2. dps heals  
3. uld scholo  

Think of each criteria level (1, 2, 3) as an "**AND**" and the criteria in the level as an "**OR**"  
So the above criteria would alert when someone says (`lfm` or `lf1m`) AND (`dps` OR `heals`) AND (`uld` OR `scholo`)  
But if they don't say something that matches a value from each criteria it is ignored  
Matches: "LF1M DPS ULD", "LFM HEALS ULD", "LFM DPS SCHOLO", etc..  
Ignored: "DPS LFG ULD", "SCHOLO need 1 more DPS", "LF TANK ULD" etc..  

### Chosing the Right Criteria -- Troubleshooting
If you think you may be missing some chat messages, keep an eye on chat to see whats being said  
Did someone say `LF1M` and you were only matching on `LFM`?  
Matches are case-insensitive, so no need to add `DPS` and `dps` etc...  
If some Options UI elements aren't showing up after an update, click the `Defaults` button to reset  

#### I'd love to hear your feedback, please leave comments or open tickets for feature requests and issues  
&nbsp;  
&nbsp;  

## 🎉Version 1.2.1 has some **MAJOR** Updates!   👏👏 👏
### Dynamic Channels
* Channels are noy Dynamically generated from your current list of chanels
### Add Dynamic Criteria:  
* Add +/- buttons to the Match Criteria  
* you can now dynamically add or remove criteria
### Add Popup Notification
* Alerts are now sent through Popup Notification In Game!!
* Popups Options  
    * Whisper: sends the configured whisper message to the player who sent the chat message
    * Invite: invites tha player who sent the message
    * Ignore: Ignores the message... popups auto ignore after 20 seconds, or there is another alert
