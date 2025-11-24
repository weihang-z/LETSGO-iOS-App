# Travel App – Tap3-4 Feature Overview

This branch using local mock data to simulate group travel, journals, and personal profile features. Below is the current feature explanation and the roadmap for upcoming improvements.

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
