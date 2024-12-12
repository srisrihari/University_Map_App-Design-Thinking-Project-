from pykml import parser
from os import path
from models import db, Location

def parse_kml_file(kml_path):
    """Parse KML file and return list of locations"""
    with open(kml_path, 'rb') as f:
        root = parser.parse(f).getroot()
        
    locations = []
    
    # Find all placemarks in the KML file
    for placemark in root.findall('.//{http://www.opengis.net/kml/2.2}Placemark'):
        try:
            name = str(placemark.name)
            description = str(placemark.description) if hasattr(placemark, 'description') else None
            
            # Extract coordinates
            point = placemark.Point if hasattr(placemark, 'Point') else None
            if point:
                coords = str(point.coordinates).split(',')
                longitude = float(coords[0])
                latitude = float(coords[1])
                
                # Determine type based on description or folder structure
                location_type = 'building'  # default type
                if description and 'washroom' in description.lower():
                    location_type = 'washroom'
                elif description and 'lecture' in description.lower():
                    location_type = 'lecture_hall'
                
                locations.append({
                    'name': name,
                    'latitude': latitude,
                    'longitude': longitude,
                    'type': location_type,
                    'description': description
                })
                
        except Exception as e:
            print(f"Error parsing placemark: {e}")
            continue
            
    return locations

def import_kml_to_db(kml_path):
    """Import KML data into the database"""
    locations = parse_kml_file(kml_path)
    
    for loc_data in locations:
        location = Location(
            name=loc_data['name'],
            latitude=loc_data['latitude'],
            longitude=loc_data['longitude'],
            type=loc_data['type'],
            description=loc_data['description']
        )
        db.session.add(location)
    
    try:
        db.session.commit()
        return len(locations)
    except Exception as e:
        db.session.rollback()
        raise e
