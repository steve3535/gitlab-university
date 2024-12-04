# Project 2: Contact Manager Project

## Project Overview
We'll build a command-line contact manager in Python that will:
- Store contacts (name, email, phone)
- Allow adding/viewing/updating contacts
- Save data to a JSON file
- Include search functionality

## Phase 1: Basic Setup and First Feature

```bash
# Create project directory
git init contact-manager
cd contact-manager

# Create initial structure
touch contacts.py contacts.json README.md
```

### Initial README
```bash
cat > README.md << 'EOL'
# Contact Manager

A simple command-line contact management system.

## Features
- Store contact information
- View all contacts
- Search contacts
- Update contact details

## Usage
Run `python contacts.py` to start the program.
EOL
```
```bash 
# Initial commit
git add README.md
git commit -m "Initial commit: Add README with project description"
```

### Basic Contact Manager Implementation
```python
cat > contacts.py << 'EOL'
import json
import sys

def load_contacts():
    try:
        with open('contacts.json', 'r') as f:
            content = f.read()
            return json.loads(content) if content else []
    except FileNotFoundError:
        return []

def save_contacts(contacts):
    with open('contacts.json', 'w') as f:
        json.dump(contacts, f, indent=2)

def add_contact(contacts, name, email, phone):
    contact = {
        "name": name,
        "email": email,
        "phone": phone
    }
    contacts.append(contact)
    save_contacts(contacts)
    print(f"Added contact: {name}")

def list_contacts(contacts):
    if not contacts:
        print("No contacts found.")
        return
    for i, contact in enumerate(contacts, 1):
        print(f"{i}. {contact['name']} - {contact['email']} - {contact['phone']}")

def main():
    contacts = load_contacts()
    if len(sys.argv) < 2:
        print("Usage: python contacts.py [add|list]")
        sys.exit(1)

    command = sys.argv[1]
    if command == "add" and len(sys.argv) == 5:
        add_contact(contacts, sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "list":
        list_contacts(contacts)
    else:
        print("Invalid command or arguments")

if __name__ == "__main__":
    main()
EOL
```
```bash
# check implementation
python contacts.py add "John Doe" "john@example.com" "+352-123-456-789"
python contacts.py add "Jane Smith" "jane@example.com" "+352-098-765-4321"
python contacts.py list
```
```bash
# If tests are ok, add and commit the code
git add contacts.py
git commit -m "Add basic contact management functionality"

# Commit the data file
git add contacts.json
git commit -m "Add initial test contacts"
```

## Phase 2: Add Search Feature (With a Bug)

```python
# Update contacts.py to add search, but with a bug that affects core functionality
cat > contacts.py << 'EOL'
import json
import sys

def load_contacts():
    try:
        with open('contacts.json', 'r') as f:
            content = f.read()
            return json.loads(content) if content else []
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def save_contacts(contacts):
    for contact in contacts:
        contact['name'] = contact['name']
    with open('contacts.json', 'w') as f:
        json.dump(contacts, f, indent=2)

def add_contact(contacts, name, email, phone):
    contact = {
        "name": name,
        "email": email,
        "phone": phone
    }
    contacts.append(contact)
    save_contacts(contacts)
    print(f"Added contact: {name}")

def list_contacts(contacts):
    if not contacts:
        print("No contacts found.")
        return
    for i, contact in enumerate(contacts, 1):
        print(f"{i}. {contact['name'].lower()} - {contact['email']} - {contact['phone']}")

def search_contacts(contacts, query):
    results = []
    query = query.lower()
    for contact in contacts:
        if query in contact["name"].lower() or \
           query in contact["email"].lower() or \
           query in contact["phone"]:
            results.append(contact)
    return results

def main():
    contacts = load_contacts()
    if len(sys.argv) < 2:
        print("Usage: python contacts.py [add|list|search]")
        sys.exit(1)

    command = sys.argv[1]
    if command == "add" and len(sys.argv) == 5:
        add_contact(contacts, sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "list":
        list_contacts(contacts)
    elif command == "search" and len(sys.argv) == 3:
        results = search_contacts(contacts, sys.argv[2])
        if results:
            print(f"Found {len(results)} matches:")
            for contact in results:
                print(f"{contact['name']} - {contact['email']} - {contact['phone']}")
        else:
            print("No contacts found.")
    else:
        print("Invalid command or arguments")

if __name__ == "__main__":
    main()
EOL
```

### Git restore: UNDO UNCOMMITED CHANGES (primarily)
```bash
# Try the search feature 
python contacts.py search "Jane"
# Try the list feature
python contacts.py list
# Have you spot the issue ?
```
```bash
# Oh no! Let's look at what changed - TIP: pay attention at the list method definition
git diff --name-status
```
```bash
git diff contacts.py
```
```bash
git diff HEAD -- contacts.py
```
```bash
git status -s
```
```bash
# We can restore the previous working version
git restore contacts.py
```
```bash
# Check that it's back to the working version
git status
python contacts.py list  # Should work again
```

## Phase 3: Adding Delete Feature

```python
import json
import sys

def load_contacts():
    try:
        with open('contacts.json', 'r') as f:
            content = f.read()
            return json.loads(content) if content else []
    except FileNotFoundError:
        return []

def save_contacts(contacts):
    with open('contacts.json', 'w') as f:
        json.dump(contacts, f, indent=2)

def add_contact(contacts, name, email, phone):
    contact = {
        "name": name,
        "email": email,
        "phone": phone
    }
    contacts.append(contact)
    save_contacts(contacts)
    print(f"Added contact: {name}")

def list_contacts(contacts):
    if not contacts:
        print("No contacts found.")
        return
    for i, contact in enumerate(contacts, 1):
        print(f"{i}. {contact['name']} - {contact['email']} - {contact['phone']}")

# Update contacts.py with delete function
def delete_contact(contacts, index):
    deleted = contacts.pop(index)
    save_contacts(contacts)
    print(f"Deleted contact: {deleted['name']}")

def main():
    contacts = load_contacts()
    if len(sys.argv) < 2:
        print("Usage: python contacts.py [add|list]")
        sys.exit(1)

    command = sys.argv[1]
    if command == "add" and len(sys.argv) == 5:
        add_contact(contacts, sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "list":
        list_contacts(contacts)
    elif command == "delete" and len(sys.argv) == 3:
        try:
            index = int(sys.argv[2]) - 1
            delete_contact(contacts, index)
        except (ValueError, IndexError) as e:
            print(f"Error: {e}")
    else:
        print("Invalid command or arguments")

if __name__ == "__main__":
    main()
```  
```bash
# Commit the changes
git add contacts.py
git commit -m "Add delete functionality"
```

### Git revert: UNDO COMMITED CHANGES
```bash
# Try deleting a contact (might cause data loss)
python contacts.py delete 1
python contacts.py list
```
```bash
# commit our database of contacts although it has been altered !
git status
git commit -am 'contacts.json data loss'
```
```bash
# Oh no! The delete function is dangerous! Let's restore our data
git revert HEAD
```
```bash
# A new commit reprsenting the revert has been created
git log --oneline
```
```bash
# Check that we have our data back
python contacts.py list
```
```bash
# should we remove completely the delete functionality ?
git checkout <COMMIT_delete_func>~1 -- contacts.py
```
<br />
## [<<Previous](./2-git-basics-1.md) &nbsp;&nbsp;[>>Next](./4-work-with-remote-101.md)
