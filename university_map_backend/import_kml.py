import requests
import sys
import os

def import_kml_data(kml_path):
    if not os.path.exists(kml_path):
        print(f"Error: KML file not found at {kml_path}")
        return
        
    try:
        response = requests.post(
            'http://localhost:5000/import-kml',
            json={'kml_path': kml_path}
        )
        
        if response.status_code == 200:
            print(response.json()['message'])
        else:
            print(f"Error: {response.json().get('error', 'Unknown error')}")
            
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to server: {e}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python import_kml.py <path_to_kml_file>")
        sys.exit(1)
        
    kml_path = sys.argv[1]
    import_kml_data(kml_path)
