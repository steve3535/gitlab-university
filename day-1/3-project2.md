# Contact Manager Project

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
# Update contacts.py to add search
# [Previous functions remain the same]
def search_contacts(contacts, query):
    results = []
    for contact in contacts:
        if query in contact["name"].lower() or \
           query in contact["email"].lower() or \
           query in contact["phone"].lower:  # Bug: missing parentheses
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
        results = search_contacts(contacts, sys.argv[2].lower())
        if results:
            print(f"Found {len(results)} contacts:")
            for contact in results:
                print(f"{contact['name']} - {contact['email']} - {contact['phone']}")
        else:
            print("No contacts found.")
    else:
        print("Invalid command or arguments")

if __name__ == "__main__":
    main()
EOL

# Commit the changes
git add contacts.py
git commit -m "Add search functionality"
```

### Learning Moment: git restore
```bash
# Try the search feature (it will fail due to the bug)
python contacts.py search "john"

# Oh no! Let's look at what changed
git diff HEAD

# We can restore the previous working version
git restore --source HEAD^ contacts.py

# Check that it's back to the working version
git status
python contacts.py list  # Should work again
```

## Phase 3: Adding Delete Feature (With Wrong Implementation)

```bash
# Update contacts.py with delete function
cat > contacts.py << 'EOL'
# [Previous imports and functions]

def delete_contact(contacts, index):
    # Bug: directly using index without checking bounds
    deleted = contacts.pop(index)
    save_contacts(contacts)
    print(f"Deleted contact: {deleted['name']}")

def main():
    contacts = load_contacts()
    if len(sys.argv) < 2:
        print("Usage: python contacts.py [add|list|search|delete]")
        sys.exit(1)

    command = sys.argv[1]
    # [Previous command handlers]
    elif command == "delete" and len(sys.argv) == 3:
        try:
            index = int(sys.argv[2]) - 1
            delete_contact(contacts, index)
        except (ValueError, IndexError) as e:
            print(f"Error: {e}")
    else:
        print("Invalid command or arguments")

EOL

# Commit the changes
git add contacts.py
git commit -m "Add delete functionality"
```

### Learning Moment: git revert
```bash
# Try deleting a contact (might cause data loss)
python contacts.py delete 1

# Oh no! The delete function is dangerous! Let's revert the commit
git revert HEAD

# Check that we're back to the safe version
git log --oneline
python contacts.py list
```

## Phase 4: Experimental Feature (To Demonstrate git reset)

```bash
# Add experimental export feature
cat >> contacts.py << 'EOL'
def export_contacts(contacts, format='csv'):
    if format == 'csv':
        with open('contacts.csv', 'w') as f:
            f.write("Name,Email,Phone\n")
            for contact in contacts:
                f.write(f"{contact['name']},{contact['email']},{contact['phone']}\n")
    elif format == 'xml':
        # Incomplete XML implementation
        pass

# Update main() to include export
EOL

# Add the changes
git add contacts.py
git commit -m "Add experimental export feature"

# Make some more experimental changes
# Add HTML export, YAML export, etc.
# Commit these changes
```

### Learning Moment: git reset
```bash
# Decide the experimental feature is not ready
git log --oneline  # Find the commit before experimental features

# Reset to before the experimental changes
git reset --hard HEAD~1

# Or with git reset --soft to keep changes in staging
git reset --soft HEAD~1
```

## Learning Outcomes
After completing this project, students will understand:
1. How to use git restore to undo uncommitted changes
2. When to use git revert for safe history modification
3. Different types of git reset and their use cases
4. How to compare different versions of files
5. Best practices for maintaining a clean Git history

## Extended Exercises
1. Try different types of git reset (--soft, --mixed, --hard)
2. Practice git restore with different sources
3. Compare changes between any two commits
4. Recover from accidental deletions
