import { createServer, Packet } from 'dns2'

// Create a DNS server
const server = createServer({
    udp: true,
    handle: (request, send, rinfo) => {
        const response = Packet.createResponseFromRequest(request);
        const [question] = request.questions;
        const { name } = question;

        // Handle 'A' record requests
        if (question.type === Packet.TYPE.A) {
            response.answers.push({
                name,
                type: Packet.TYPE.A,
                class: Packet.CLASS.IN,
                ttl: 300,
                address: '93.184.216.34' // Example IP address for demonstration
            });
        }

        // Send the response back to the client
        send(response);
    }
});

// Start listening on port 53
server.on('request', (request, response, rinfo) => {
    console.log(`Received request for ${request.questions[0].name}`);
});

server.on('error', (error) => {
    console.error('DNS server error:', error);
});

// Listen on port 53 for DNS queries
server.listen(53, '0.0.0.0', () => {
    console.log('DNS server listening on port 53');
});
