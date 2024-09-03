from flask import Flask, jsonify, request, render_template
from datetime import datetime
import pytz

app = Flask(__name__)

time_zones = pytz.all_timezones

@app.route('/')
def home():
    return render_template('index.html', time_zones=time_zones)

@app.route('/current-time', methods=['GET'])
def get_current_time():
    format = request.args.get('format', 'iso')
    tz = request.args.get('tz', 'UTC')

    if tz not in time_zones:
        return jsonify({'error': 'Invalid timezone'}), 400

    now = datetime.now(pytz.timezone(tz))

    if format == 'iso':
        current_time = now.isoformat()
    elif format == 'unix':
        current_time = int(now.timestamp())
    else:
        return jsonify({'error': 'Invalid format'}), 400

    return jsonify({'current_time': current_time, 'time_zone': tz})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
