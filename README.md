# Travel App – Tap3-4 Feature Overview

This branch using local mock data to simulate group travel, journals, and personal profile features. Below is the current feature explanation and the roadmap for upcoming improvements.

---
# **Stage II – New Features, Screens & Interaction Overview**

---

## ✅ **1. Travel Groups (Tab 3) Enhancements**

### **(1) Group Filtering System**
- Added a **Filter panel** supporting City / Theme / Budget / Date filters.
- Users can tap the **“Filter”** button on the top-left to open the filter modal.
- A Reset button clears all conditions.
- Filtered results update the group list immediately.

### **(2) Group Detail Update**
- Updated the detail screen with role-based actions:
  - **Organizer →** “Edit Group”
  - **Member →** “Leave Group”
  - **Non-member →** “Join Group / Group Full”
- **Join/Leave actions now sync in real time** with the “Joined Groups” list under **My Groups & Logs** (cross-tab data consistency).

---

## ✅ **2. Create Group Page Improvements**
- Added **city** and **theme** input fields.
- These values are now part of the Group model and flow end-to-end from creation → list → detail → filters.

---

## ✅ **3. Profile Page (Tab 4) Update**
- Entire Profile page converted to a **scrollable layout (UIScrollView)** to handle longer content.
- Joined groups are no longer shown directly on the Profile page—they now live inside **My Groups & Logs**.

---

## ✅ **4. My Groups & Logs (formerly My Posts)**

### **(1) Updated Structure**
Segmented control now contains:
1. **Joined Groups**
2. **My Logs** (will later link with Tab 1 for user-generated logs)

### **(2) New Example Data for Joined Groups**
- Joined Groups now show a separate set of sample data  
  (e.g., **Seoul / Lisbon / Patagonia**)  
- This makes it easier to distinguish from the Travel Groups list in Tab 3.

### **(3) Joined Group → Detail Flow**
- Tapping a joined group opens the Group Detail page.
- Detail page includes a **Leave Group** button.
  → Leaving a group removes it immediately  
  → “Joined Groups” list refreshes instantly

---

## ✅ **5. Travel Footprint Map – New Interactive Version**

### **(1) Combined Map + City List UI**
- Map displays pins using the `visitedCities` dataset.
- Under the map is a list showing: City, Country, Notes.

### **(2) Add New City**
- A top-right “＋” button lets users manually add a city.
- Input fields include City, Country, Latitude, Longitude, Notes.
- After saving:
  - A map annotation is added
  - The city appears in the list
  - Data is stored in `UserContentDataStore`  
    (Firebase support planned for later)

### **(3) Delete City**
- The city list supports **Swipe to Delete**.
- Deleting removes both:
  - The row
  - The pin on the map
- Data store updates instantly.

---


---
## Tab 3: Travel Groups

### **Current Features**
- Displays travel groups using local mock data.
- The `GroupList` page presents groups with a custom `GroupCardCell` UI.
- Tapping a card navigates to a detailed group view (destination, budget, member count, date, etc.).
- A **“+ Create”** button allows users to create new group entries; saved data immediately refreshes the list (in-memory storage).
- All data is currently stored locally in memory with no Firebase or external database integration yet.

### **Planned Improvements**
- **Firebase Integration**: View the newest travel groups instantly using real-time updates when opening Tab 3.
- **Filter System**: Filter groups by budget, date, city, or theme.
- **Enhanced Group Detail Page**: Show organizer profile, member list, and join/leave functionality.
---

## Tab 4: My Profile

### **Current Features**
- Profile Overview page presents:
  - User avatar  
  - Username  
  - Bio  
  - Three statistic cards:
    - **Cities Visited**
    - **Travel Days**
    - **Journal Count**
- Two main navigation entries:
  - **Edit Profile**: Allows editing username and bio; updates UI through callback closure (data stored locally).
  - **My Posts**: Switches between “Groups / Journals” to display the user’s sample travel groups and journals.

### **Planned Improvements**
- **Firebase Sync for Profile**: Avatar, username, bio, and travel statistics will be uploaded and synced via Firebase.
- **Avatar Editing & Upload** (Firebase Storage).
- **Post History Detail Pages**: Open individual journal or group posts for a full detailed view.
- **Followers / Following System**: View follower list, following list, and other users’ profiles.
- **Travel Footprint Map**: Visual map showing all cities the user has visited.

---
