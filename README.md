# Bamm’s Medic – Emergency Medical Service Script
A FiveM script that allows players to call a doctor NPC when dead, get revived, and pay for medical treatment. Works with QBCore framework.

**Features:**
- Call a doctor NPC if EMS is unavailable or offline.
- Automatic vehicle and NPC spawn for the doctor.
- Progress bar and animation for revival.
- Payment system for cash or bank with configurable price.
- Notifications for treatment, errors, and status updates.
- Prevents multiple uses while waiting for NPC.

**Installation:**  
Place the resource in your server’s resource folder. Add it to `server.cfg` using:

**Configuration:**  
- `Config.Doctor` – Minimum number of EMS online to prevent NPC usage.  
- `Config.Price` – Amount charged to revive a player.  
- `Config.ReviveTime` – Time in milliseconds the NPC takes to revive the player.  

**Usage:**  
- When dead, type `/help` in chat.  
- If EMS are below the configured minimum, an NPC doctor spawns with a medical vehicle and revives you.  
- You will automatically be charged the configured price.  
- If EMS are online, a notification will inform you and the NPC will not spawn.  
- The NPC will drive to your location, perform CPR, and leave after treatment.

**Notes:**  
- Only works when the player is dead or in last stand.  
- Integrates with QBCore framework.  
- NPC spawn uses the `romero` vehicle and `mp_m_bogdangoon` ped model.  
- Uses lib.notify for notifications.  
- Prevents repeated spamming while the NPC is en route.  

**Author:**  
Bamm – [GitHub Profile](https://github.com/MrTolska)
