import { db } from '$lib/server/db';
import { user } from '$lib/server/db/schema';
import { eq } from 'drizzle-orm';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

// GET all users
export const GET: RequestHandler = async () => {
	try {
		const users = await db.select().from(user);
		return json(users);
	} catch (err) {
		console.error('Failed to fetch users:', err);
		return json({ error: 'Failed to fetch users' }, { status: 500 });
	}
};

// POST - Create new user
export const POST: RequestHandler = async ({ request }) => {
	try {
		const { age } = await request.json();

		if (age === undefined || age === null) {
			return json({ error: 'Age is required' }, { status: 400 });
		}

		if (typeof age !== 'number' || age < 0) {
			return json({ error: 'Age must be a valid positive number' }, { status: 400 });
		}

		const newUser = await db
			.insert(user)
			.values({
				age
			})
			.returning();

		return json(newUser[0], { status: 201 });
	} catch (err) {
		console.error('Failed to create user:', err);
		return json({ error: 'Failed to create user' }, { status: 500 });
	}
};

// PUT - Update user
export const PUT: RequestHandler = async ({ request, url }) => {
	try {
		const id = url.searchParams.get('id');
		if (!id) {
			return json({ error: 'User ID is required' }, { status: 400 });
		}

		const { age } = await request.json();

		if (age === undefined || age === null) {
			return json({ error: 'Age is required' }, { status: 400 });
		}

		if (typeof age !== 'number' || age < 0) {
			return json({ error: 'Age must be a valid positive number' }, { status: 400 });
		}

		const updatedUser = await db
			.update(user)
			.set({ age })
			.where(eq(user.id, parseInt(id)))
			.returning();

		if (updatedUser.length === 0) {
			return json({ error: 'User not found' }, { status: 404 });
		}

		return json(updatedUser[0]);
	} catch (err) {
		console.error('Failed to update user:', err);
		return json({ error: 'Failed to update user' }, { status: 500 });
	}
};

// DELETE - Delete user
export const DELETE: RequestHandler = async ({ url }) => {
	try {
		const id = url.searchParams.get('id');
		if (!id) {
			return json({ error: 'User ID is required' }, { status: 400 });
		}

		const deletedUser = await db
			.delete(user)
			.where(eq(user.id, parseInt(id)))
			.returning();

		if (deletedUser.length === 0) {
			return json({ error: 'User not found' }, { status: 404 });
		}

		return json({ message: 'User deleted successfully', user: deletedUser[0] });
	} catch (err) {
		console.error('Failed to delete user:', err);
		return json({ error: 'Failed to delete user' }, { status: 500 });
	}
};
