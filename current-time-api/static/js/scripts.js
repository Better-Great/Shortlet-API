document.getElementById('timeForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const format = document.getElementById('format').value;
    const tz = document.getElementById('tz').value;

    fetch(`/current-time?format=${format}&tz=${tz}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('result').style.display = 'block';
            if (data.error) {
                document.getElementById('timeOutput').textContent = data.error;
            } else {
                document.getElementById('timeOutput').textContent = `Current time in ${data.time_zone}: ${data.current_time}`;
            }
        });
});

function viewRawJson() {
    const format = document.getElementById("format").value;
    const tz = document.getElementById("tz").value;
    const url = `/current-time?format=${format}&tz=${tz}`;

    window.open(url, '_blank');
}
