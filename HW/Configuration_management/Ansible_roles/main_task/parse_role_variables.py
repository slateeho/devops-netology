#!/usr/bin/env python3
"""
Script to parse vars and defaults subdirectories of all roles in ~/ansible
"""

import os
import yaml
from pathlib import Path

def find_all_roles(base_path="/root/root/roles"):
    """Find all role directories"""
    roles = []
    
    if not os.path.exists(base_path):
        print(f"Path {base_path} does not exist")
        return roles
    
    for item in os.listdir(base_path):
        role_path = os.path.join(base_path, item)
        if os.path.isdir(role_path):
            roles.append({
                'name': item,
                'path': role_path
            })
    
    return sorted(roles, key=lambda x: x['name'])

def load_yaml_file(file_path):
    """Load and parse a YAML file"""
    try:
        with open(file_path, 'r') as f:
            content = yaml.safe_load(f)
            return content if content else {}
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def parse_role_variables(role_info):
    """Parse vars and defaults from a role"""
    role_name = role_info['name']
    role_path = role_info['path']
    
    variables = {
        'vars': {},
        'defaults': {}
    }
    
    # Parse vars/main.yml
    vars_file = os.path.join(role_path, 'vars', 'main.yml')
    if os.path.exists(vars_file):
        variables['vars'] = load_yaml_file(vars_file)
    
    # Parse defaults/main.yml
    defaults_file = os.path.join(role_path, 'defaults', 'main.yml')
    if os.path.exists(defaults_file):
        variables['defaults'] = load_yaml_file(defaults_file)
    
    return variables

def format_value(value, max_length=60):
    """Format variable value for display"""
    if isinstance(value, dict):
        return f"dict({len(value)} keys)"
    elif isinstance(value, list):
        return f"list({len(value)} items)"
    else:
        str_value = str(value)
        if len(str_value) > max_length:
            return str_value[:max_length-3] + "..."
        return str_value

def main():
    """Main function to parse and display all role variables"""
    
    print("🔍 Parsing vars and defaults from all roles in ~/ansible/roles")
    print("=" * 80)
    
    # Find all roles
    roles = find_all_roles()
    
    if not roles:
        print("No roles found")
        return
    
    print(f"Found {len(roles)} roles:")
    for role in roles:
        print(f"  - {role['name']}")
    
    print("\n" + "=" * 80)
    print("📋 VARIABLES BY ROLE")
    print("=" * 80)
    
    all_variables = {}
    
    # Parse each role
    for role_info in roles:
        role_name = role_info['name']
        
        print(f"\n🔧 Role: {role_name}")
        print("-" * 50)
        
        variables = parse_role_variables(role_info)
        all_variables[role_name] = variables
        
        # Display vars
        if variables['vars']:
            print(f"📁 vars/main.yml ({len(variables['vars'])} variables):")
            for var_name, var_value in sorted(variables['vars'].items()):
                print(f"  🔹 {var_name}: {format_value(var_value)}")
        else:
            print("📁 vars/main.yml: No variables")
        
        # Display defaults
        if variables['defaults']:
            print(f"📁 defaults/main.yml ({len(variables['defaults'])} variables):")
            for var_name, var_value in sorted(variables['defaults'].items()):
                print(f"  🔸 {var_name}: {format_value(var_value)}")
        else:
            print("📁 defaults/main.yml: No variables")
    
    # Summary analysis
    print("\n" + "=" * 80)
    print("📊 SUMMARY ANALYSIS")
    print("=" * 80)
    
    # Collect all variable names
    all_var_names = {}
    total_vars = 0
    total_defaults = 0
    
    for role_name, variables in all_variables.items():
        # Process vars
        for var_name in variables['vars'].keys():
            if var_name not in all_var_names:
                all_var_names[var_name] = []
            all_var_names[var_name].append(f"{role_name}(vars)")
            total_vars += 1
        
        # Process defaults
        for var_name in variables['defaults'].keys():
            if var_name not in all_var_names:
                all_var_names[var_name] = []
            all_var_names[var_name].append(f"{role_name}(defaults)")
            total_defaults += 1
    
    print(f"Total variables in vars: {total_vars}")
    print(f"Total variables in defaults: {total_defaults}")
    print(f"Unique variable names: {len(all_var_names)}")
    
    # Find variable name conflicts
    print(f"\n🚨 VARIABLE NAME CONFLICTS:")
    print("-" * 50)
    
    conflicts = {name: locations for name, locations in all_var_names.items() if len(locations) > 1}
    
    if conflicts:
        for var_name, locations in sorted(conflicts.items()):
            print(f"  ⚠️  '{var_name}' defined in: {', '.join(locations)}")
    else:
        print("  ✅ No variable name conflicts found")
    
    # Port variables analysis
    print(f"\n🔌 PORT VARIABLES:")
    print("-" * 50)
    
    port_vars = []
    
    for role_name, variables in all_variables.items():
        # Check vars
        for var_name, var_value in variables['vars'].items():
            if 'port' in var_name.lower() and isinstance(var_value, (int, str)):
                try:
                    port_num = int(var_value)
                    if 1 <= port_num <= 65535:
                        port_vars.append({
                            'role': role_name,
                            'name': var_name,
                            'port': port_num,
                            'source': 'vars'
                        })
                except (ValueError, TypeError):
                    pass
        
        # Check defaults
        for var_name, var_value in variables['defaults'].items():
            if 'port' in var_name.lower() and isinstance(var_value, (int, str)):
                try:
                    port_num = int(var_value)
                    if 1 <= port_num <= 65535:
                        port_vars.append({
                            'role': role_name,
                            'name': var_name,
                            'port': port_num,
                            'source': 'defaults'
                        })
                except (ValueError, TypeError):
                    pass
    
    if port_vars:
        # Sort by port number
        port_vars.sort(key=lambda x: x['port'])
        for pv in port_vars:
            print(f"  🔌 {pv['role']}.{pv['name']} ({pv['source']}): {pv['port']}")
    else:
        print("  No port variables found")
    
    # Variables by type
    print(f"\n📊 VARIABLES BY TYPE:")
    print("-" * 50)
    
    type_counts = {}
    
    for role_name, variables in all_variables.items():
        for source in ['vars', 'defaults']:
            for var_name, var_value in variables[source].items():
                var_type = type(var_value).__name__
                if var_type not in type_counts:
                    type_counts[var_type] = 0
                type_counts[var_type] += 1
    
    for var_type, count in sorted(type_counts.items(), key=lambda x: x[1], reverse=True):
        print(f"  📈 {var_type}: {count}")

if __name__ == "__main__":
    main()
