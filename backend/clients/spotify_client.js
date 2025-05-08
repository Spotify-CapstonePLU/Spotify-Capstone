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

    async createPlaylist(playlist_name, userId) {
        try {
            const response = await this.api.post(`/users/${userId}/playlists`, {
                "name": playlist_name,
                "public": true,
                "collaborative": false
            })
            return await response.data
        } catch (error) {
            console.error('Error creating playlist:', error.response?.data || error.message);
            throw error
        }
    }

    // Search for songs
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

    // Get user's playlists
    async getUserPlaylists() {
        try {
            const response = await this.api.get('/me/playlists?limit=50&offset=0');
            return response.data;
        } catch (error) {
            console.error('Error fetching playlists:', error.response?.data || error.message);
            throw error;
        }
    }

    // Get user's playlist by id
    async getUserPlaylist(playlistId) {
        try {
            const response = await this.api.get(`/me/playlists/${playlistId}`);
            return response.data.tracks.items;
        } catch (error) {
            console.error('Error finding playlist:', error.response?.data || error.message);
            throw error;
        }
    }

    // Get all songs from user's playlist by playlist id
    async getUserPlaylistSongs(playlistId) {
        try {
            const response = await this.api.get(`/playlists/${playlistId}`, {
                params: { fields: 'tracks.items(track(album.name, name, id, artists.name, duration_ms))' }
            });
            return response.data;
        } catch (error) {
            console.error('Error fetching playlist songs:', error.response?.data || error.message);
            throw error;
        }
    }

    async getSongsById(songIds) {
        try {
            const response = await this.api.get('/tracks', {
                params: {
                    ids: songIds.join(',')
                }
            });

            const tracks = await response.data.tracks.map((track) => ({
                id: track.id,
                name: track.name,
                imageUrl: track.album.images?.[0]?.url
            }))

            return tracks;
        } catch (error) {
            console.error('Error fetching songs by id:', error.response?.data || error.message);
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
