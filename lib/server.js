const {createServer} = require("node:http");
const mongoose = require("mongoose");

const hostname = '0.0.0.0';
const port = 3000;

mongoose.connect('mongodb://127.0.0.1:27017/beHuman')
    .then(() => {
        console.log('connected to MongoDB');
    })
    .catch((error) => {
        console.error('connection error', error);
    });

const activitySchema = new mongoose.Schema({
    activityDesc: {type: String, required: true},
    startTime: {
        hour: {type: Number, required: true, min: 0, max: 23},
        minute: {type: Number, required: true, min: 0, max: 59}
    },
    endTime: {
        hour: {type: Number, required: true, min: 0, max: 23},
        minute: {type: Number, required: true, min: 0, max: 59}
    },
    day: {type: Number, required: true, min: 0, max: 6}, // 0: sunday, 6: saturday
});

const Activity = mongoose.model('Activity', activitySchema);


const server = createServer(async (req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    const url = new URL(req.url, `http://${req.headers.host}`);

    if(req.method === 'OPTIONS') {
        res.statusCode = 204; // success and no content returned
        res.end();
    }

    else if(req.method === 'POST') {
        let body = '';

        req.on('data', (chunk) => {
            body += chunk;
        })

        req.on('end', async () => {
            try{
                const bodyObject = JSON.parse(body);

                const activity = await Activity.create(bodyObject);
                
                res.statusCode = 201; // data saved successfully
                res.setHeader('Content-Type', 'application/json');
                res.end(JSON.stringify({
                    success: true,
                    message: "data saved",
                    dataID: activity._id
                }));
            }
            catch(error) {
                res.statusCode = 400; // client side error
                res.setHeader('Content-Type', 'application/json');
                res.end(JSON.stringify({
                    success: false,    
                    message: "error",
                    error: error.message
                }));
            }
        })
    }

    else if(req.method === 'GET'){
        try{
            let id = url.searchParams.get('id');
            let day = url.searchParams.get('day');
            day = Number(day);

            if(id === null){
                const activities = await Activity.find({day: day});
                
                if(activities.length === 0){
                    res.statusCode = 404; // data not found
                    res.setHeader('Content-Type', 'application/json');
                    res.end(JSON.stringify({
                        success: false,
                        message: "no data found"
                    }));
                    return;
                }

                res.statusCode = 200; // request succeeded
                res.setHeader('Content-Type', 'application/json');
                res.end(JSON.stringify(activities));
            }
            else{
                const activity = await Activity.findById(id);

                if(activity){
                    res.statusCode = 200; // request succeeded
                    res.setHeader('Content-Type', 'application/json');
                    res.end(JSON.stringify(activity));
                    return;
                }

                res.statusCode = 404; // data not found
                res.setHeader('Content-Type', 'application/json');
                res.end(JSON.stringify({
                    success: false,
                    message: "data not found"
                }));
            }
        }
        catch(error){
            res.statusCode = 500; // server side error
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify({
                success: false,
                message: 'server or database error',
                error: error.message
            }))
        }
    }
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}`);
});