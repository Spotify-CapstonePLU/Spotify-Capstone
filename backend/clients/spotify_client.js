import axios from 'axios';

export class SpotifyClient {
    constructor(accessToken) {
        this.accessToken = accessToken;
        this.api = axios.create({
            baseURL: 'https://api.spotify.com/v1',
            headers: {
                Authorization: `Bearer ${this.accessToken}`
            }
        });
    }

    async createPlaylist(playlist_name, userID) {
        try {
            const response = await this.api.post(`/users/${userID}/playlists`, {
                "name": playlist_name,
                "public": true,
                "collaborative": false
            })
            // console.log(await response.data)
            return await response.data
        } catch (error) {
            console.error('Error creating playlist:', error.response?.data || error.message);
            throw error
        }
    }

    // Method to search for songs
    async searchSongs(query) {
        try {
            const response = await this.api.get('/search', {
                params: { q: query, type: 'track' }
            });
            return response.data;
        } catch (error) {
            console.error('Error searching songs:', error.response?.data || error.message);
            throw error;
        }
    }

    // Method to get the authenticated user's ID
    async getUserData() {
        try {
            const response = await this.api.get('/me');
            return await response.data;
        } catch (error) {
            console.error('Error fetching user ID:', error.response?.data || error.message);
            throw error;
        }
    }

    // Method to get the authenticated user's playlists
    async getUserPlaylists() {
        try {
            const response = await this.api.get('/me/playlists');
            return response.data;
        } catch (error) {
            console.error('Error fetching playlists:', error.response?.data || error.message);
            throw error;
        }
    }

    // Optional: Method to update the access token dynamically
    setAccessToken(newToken) {
        this.accessToken = newToken;
        this.api.defaults.headers.Authorization = `Bearer ${newToken}`;
    }
}


// Usage Example
// const client = new SpotifyClient('your_access_token');

// client.searchSongs('Imagine Dragons')
//     .then(data => console.log(data))
//     .catch(error => console.error(error));

// client.getUserID()
//     .then(userID => console.log('User ID:', userID))
//     .catch(error => console.error(error));

// client.getUserPlaylists()
//     .then(playlists => console.log('Playlists:', playlists))
//     .catch(error => console.error(error));
