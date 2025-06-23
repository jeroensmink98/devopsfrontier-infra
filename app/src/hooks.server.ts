import type { Handle } from '@sveltejs/kit';

export const handle: Handle = async ({ event, resolve }) => {
	// Get the response from the route handler
	const response = await resolve(event);

	// Check if this is an API route (starts with /api)
	if (event.url.pathname.startsWith('/api')) {
		// Clone the response to modify headers
		const modifiedResponse = new Response(response.body, {
			status: response.status,
			statusText: response.statusText,
			headers: {
				...Object.fromEntries(response.headers.entries()),
				'Content-Type': 'application/json',
				'Cache-Control': 'no-cache',
				'Access-Control-Allow-Origin': '*',
				'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
				'Access-Control-Allow-Headers': 'Content-Type, Authorization'
			}
		});

		return modifiedResponse;
	}

	// Return the original response for non-API routes
	return response;
};
