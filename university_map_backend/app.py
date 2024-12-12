from flask import Flask, jsonify, request
from flask_cors import CORS
from models import db, Location
from utils.kml_parser import import_kml_to_db
import os

app = Flask(__name__)
CORS(app)

# Configure SQLite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///locations.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# Create tables
with app.app_context():
    db.create_all()

@app.route('/locations', methods=['GET'])
def get_locations():
    """Get all locations or filter by type"""
    location_type = request.args.get('type')
    if location_type:
        locations = Location.query.filter_by(type=location_type).all()
    else:
        locations = Location.query.all()
    return jsonify([loc.to_dict() for loc in locations])

@app.route('/locations/<int:loc_id>', methods=['GET'])
def get_location(loc_id):
    """Get a specific location by ID"""
    location = Location.query.get_or_404(loc_id)
    return jsonify(location.to_dict())

@app.route('/locations/search', methods=['GET'])
def search_locations():
    """Search locations by name"""
    query = request.args.get('q', '').lower()
    locations = Location.query.filter(Location.name.ilike(f'%{query}%')).all()
    return jsonify([loc.to_dict() for loc in locations])

@app.route('/locations', methods=['POST'])
def add_location():
    """Add a new location"""
    data = request.json
    new_location = Location(
        name=data['name'],
        latitude=data['latitude'],
        longitude=data['longitude'],
        type=data['type'],
        description=data.get('description', '')
    )
    db.session.add(new_location)
    db.session.commit()
    return jsonify(new_location.to_dict()), 201

@app.route('/import-kml', methods=['POST'])
def import_kml():
    """Import locations from KML file"""
    try:
        kml_path = request.json.get('kml_path')
        if not kml_path or not os.path.exists(kml_path):
            return jsonify({'error': 'Invalid KML file path'}), 400
            
        count = import_kml_to_db(kml_path)
        return jsonify({'message': f'Successfully imported {count} locations'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
