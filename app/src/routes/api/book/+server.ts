import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { bookController } from '$lib/server/controllers/bookController';

// GET all books
export const GET: RequestHandler = async () => {
	const result = await bookController.getAllBooks();

	if (!result.success) {
		return json({ error: result.error }, { status: 500 });
	}

	return json(result.data);
};

// POST - Create new book
export const POST: RequestHandler = async ({ request }) => {
	try {
		const { title, author, published_date } = await request.json();

		// Input validation
		if (!title || !author) {
			return json({ error: 'Title and author are required' }, { status: 400 });
		}

		if (typeof title !== 'string' || typeof author !== 'string') {
			return json({ error: 'Title and author must be strings' }, { status: 400 });
		}

		if (published_date && typeof published_date !== 'string') {
			return json({ error: 'Published date must be a string' }, { status: 400 });
		}

		const result = await bookController.createBook({ title, author, published_date });

		if (!result.success) {
			return json({ error: result.error }, { status: 500 });
		}

		return json(result.data, { status: 201 });
	} catch (err) {
		console.error('Failed to parse request:', err);
		return json({ error: 'Invalid JSON in request body' }, { status: 400 });
	}
};

// PUT - Update book
export const PUT: RequestHandler = async ({ request, url }) => {
	try {
		const idParam = url.searchParams.get('id');
		if (!idParam) {
			return json({ error: 'Book ID is required' }, { status: 400 });
		}

		const id = parseInt(idParam);
		if (isNaN(id)) {
			return json({ error: 'Book ID must be a valid number' }, { status: 400 });
		}

		const { title, author, published_date } = await request.json();

		// Input validation
		if (!title || !author) {
			return json({ error: 'Title and author are required' }, { status: 400 });
		}

		if (typeof title !== 'string' || typeof author !== 'string') {
			return json({ error: 'Title and author must be strings' }, { status: 400 });
		}

		if (published_date && typeof published_date !== 'string') {
			return json({ error: 'Published date must be a string' }, { status: 400 });
		}

		const result = await bookController.updateBook(id, { title, author, published_date });

		if (!result.success) {
			const status = result.error === 'Book not found' ? 404 : 500;
			return json({ error: result.error }, { status });
		}

		return json(result.data);
	} catch (err) {
		console.error('Failed to parse request:', err);
		return json({ error: 'Invalid JSON in request body' }, { status: 400 });
	}
};

// DELETE - Delete book
export const DELETE: RequestHandler = async ({ url }) => {
	const idParam = url.searchParams.get('id');
	if (!idParam) {
		return json({ error: 'Book ID is required' }, { status: 400 });
	}

	const id = parseInt(idParam);
	if (isNaN(id)) {
		return json({ error: 'Book ID must be a valid number' }, { status: 400 });
	}

	const result = await bookController.deleteBook(id);

	if (!result.success) {
		const status = result.error === 'Book not found' ? 404 : 500;
		return json({ error: result.error }, { status });
	}

	return json({ message: 'Book deleted successfully', book: result.data });
};
