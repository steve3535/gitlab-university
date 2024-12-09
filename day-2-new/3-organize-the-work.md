# Exercise: Organizing the Hats for Cats Application

## Group Structure

1. Create main group "Hats for Cats"
2. Create subgroup "Mobile" under main group
3. Create the following projects:
   - Web (under Hats for Cats)
   - Documentation (under Hats for Cats)
   - iOS (under Mobile)
   - Android (under Mobile)

### Step 1: Creating Group Structure

1. Log into gitlab.com
2. Click the "+" button at the top and select "New group"
3. For the main group:
   - Name: Hats for Cats
   - Slug: hats-for-cats (automatically generated)
   - Visibility Level: Public
   - Select "Create group"

4. Inside the Hats for Cats group, create the Mobile subgroup:
   - Click "New subgroup"
   - Name: Mobile
   - Slug: mobile
   - Visibility Level: Public

5. Now let's create all projects:

   A. Under main group "Hats for Cats":
   - Create project "Web"
     - Template: None (blank project)
     - Visibility: Public
     - Initialize with README

   - Create project "Documentation"
     - Template: None (blank project)
     - Visibility: Public
     - Initialize with README

   B. Under "Mobile" subgroup:
   - Create project "iOS"
     - Visibility: Public
     - Initialize with README

   - Create project "Android"
     - Visibility: Public
     - Initialize with README

## Step 2: Setting up the Web Project

First, let's create a focused set of labels specific to our e-commerce needs.

### Labels for Web Project
```
Priority Labels:
- ~"priority::critical" (Red) - Critical features needed for launch
- ~"priority::high" (Orange) - Core shopping features
- ~"priority::medium" (Yellow) - Important but not blocking
- ~"priority::low" (Green) - Nice to have features

Feature Areas:
- ~"area::shopping" (Blue) - Shopping-related features
- ~"area::catalog" (Purple) - Cat hat catalog features
- ~"area::checkout" (Orange) - Payment and checkout
- ~"area::user-account" (Green) - User account management

Type Labels:
- ~"type::feature" (Green) - New features
- ~"type::bug" (Red) - Bug fixes
- ~"type::ui" (Purple) - User interface work
- ~"type::payment" (Blue) - Payment-related items

Development Status:
- ~"status::planning" (Gray)
- ~"status::ready" (Blue)
- ~"status::in-progress" (Yellow)
- ~"status::review" (Purple)
- ~"status::blocked" (Red)
```

## Step 3: Create Initial Milestone

Create milestone: "MVP Launch - Basic Cat Hat Store"
Description: "Launch basic e-commerce functionality for selling cat hats online"
Due date: Set to 3 months from now

## Step 4: Create Initial Issues for Web MVP

Let's create essential issues for our basic cat hat store. Each should be labeled appropriately and added to the MVP milestone:

1. Basic Product Catalog
```markdown
Title: Implement basic cat hat catalog
Description:
### Overview
Create the basic product catalog to display our cat hats

### Requirements
- Grid view of cat hats
- Filter by cat size (S/M/L)
- Filter by hat style (Cowboy, Top Hat, Beanie, etc.)
- Sort by price
- Sort by popularity
- Basic search functionality

### Acceptance Criteria
- Users can view all available hats
- Users can filter hats by cat size
- Users can filter by hat style
- Users can sort by price (high/low)
- Users can search by hat name

/label ~"area::catalog" ~"type::feature" ~"priority::critical"
/milestone %"MVP Launch - Basic Cat Hat Store"
```

2. Shopping Cart
```markdown
Title: Implement shopping cart functionality
Description:
### Overview
Allow users to add items to cart and manage their selections

### Requirements
- Add items to cart
- Remove items from cart
- Update quantities
- Cart persistence across sessions
- Show total price
- Show number of items in cart icon

### Acceptance Criteria
- Users can add multiple hats to cart
- Users can remove items
- Users can update quantities
- Cart saves when user leaves site
- Accurate price calculation including any discounts

/label ~"area::shopping" ~"type::feature" ~"priority::critical"
/milestone %"MVP Launch - Basic Cat Hat Store"
```

3. User Account System
```markdown
Title: Create user account system
Description:
### Overview
Implement basic user account functionality

### Requirements
- User registration
- User login/logout
- Password reset
- Basic profile (name, email, address)
- Order history
- Save favorite hats

### Acceptance Criteria
- Users can register new accounts
- Users can login/logout
- Users can reset passwords
- Users can update their profile
- Users can view order history

/label ~"area::user-account" ~"type::feature" ~"priority::high"
/milestone %"MVP Launch - Basic Cat Hat Store"
```

