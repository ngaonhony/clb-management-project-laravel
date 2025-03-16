import apiClient from "../utils/apiClient";

// Cache implementation
const cache = new Map();
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

const isCacheValid = (key) => {
  const cached = cache.get(key);
  if (!cached) return false;
  return Date.now() - cached.timestamp < CACHE_DURATION;
};

const getCached = (key) => {
  if (!isCacheValid(key)) {
    cache.delete(key);
    return null;
  }
  return cache.get(key).data;
};

const setCache = (key, data) => {
  cache.set(key, {
    data,
    timestamp: Date.now()
  });
};

// Error handling
class EventServiceError extends Error {
  constructor(message, code, originalError = null) {
    super(message);
    this.name = 'EventServiceError';
    this.code = code;
    this.originalError = originalError;
  }
}

// Data validation
const validateEventData = (data) => {
  const requiredFields = ['name', 'start_date', 'end_date', 'location', 'max_participants'];
  const missingFields = requiredFields.filter(field => !data[field]);
  
  if (missingFields.length > 0) {
    throw new EventServiceError(
      `Missing required fields: ${missingFields.join(', ')}`,
      'VALIDATION_ERROR'
    );
  }

  if (new Date(data.start_date) > new Date(data.end_date)) {
    throw new EventServiceError(
      'Start date cannot be after end date',
      'VALIDATION_ERROR'
    );
  }

  if (data.max_participants < 1) {
    throw new EventServiceError(
      'Maximum participants must be at least 1',
      'VALIDATION_ERROR'
    );
  }
};

// API functions
export const getEvents = async (useCache = true) => {
  try {
    if (useCache) {
      const cachedData = getCached('events');
      if (cachedData) return cachedData;
    }

    const response = await apiClient.get("/events");
    const data = response.data;

    if (!Array.isArray(data)) {
      throw new EventServiceError(
        'Invalid response format: expected array',
        'INVALID_RESPONSE'
      );
    }

    setCache('events', data);
    return data;
  } catch (error) {
    if (error instanceof EventServiceError) throw error;
    
    throw new EventServiceError(
      "Failed to fetch events",
      'API_ERROR',
      error
    );
  }
};

export const getEventById = async (id, useCache = true) => {
  try {
    const cacheKey = `event_${id}`;
    
    if (useCache) {
      const cachedData = getCached(cacheKey);
      if (cachedData) return cachedData;
    }

    const response = await apiClient.get(`/events/${id}`);
    const data = response.data;

    if (!data || typeof data !== 'object') {
      throw new EventServiceError(
        'Invalid response format: expected object',
        'INVALID_RESPONSE'
      );
    }

    setCache(cacheKey, data);
    return data;
  } catch (error) {
    if (error instanceof EventServiceError) throw error;
    
    throw new EventServiceError(
      `Failed to fetch event with ID ${id}`,
      'API_ERROR',
      error
    );
  }
};

class EventService {

  async createEvent(eventData) {
    try {
      validateEventData(eventData);

      const formData = new FormData();
      
      // Handle file upload
      if (eventData.image instanceof File) {
        formData.append("image", eventData.image);
      }

      // Append other data
      Object.entries(eventData).forEach(([key, value]) => {
        if (key !== "image" && value !== undefined && value !== null) {
          formData.append(key, value);
        }
      });

      const response = await apiClient.post("/events", formData, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      // Clear cache after creating new event
      cache.delete('events');
      
      return response.data;
    } catch (error) {
      if (error instanceof EventServiceError) throw error;
      
      throw new EventServiceError(
        "Failed to create event",
        'API_ERROR',
        error
      );
    }
  }

  async updateEvent(id, eventData) {
    try {
      validateEventData(eventData);

      const formData = new FormData();
      
      // Handle file upload
      if (eventData.image instanceof File) {
        formData.append("image", eventData.image);
      }

      // Append other data
      const fieldsToUpdate = {
        name: eventData.name,
        location: eventData.location,
        category_id: eventData.category_id,
        start_date: eventData.start_date,
        end_date: eventData.end_date,
        max_participants: eventData.max_participants,
        content: eventData.description,
        club_id: eventData.club_id,
      };

      Object.entries(fieldsToUpdate).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          formData.append(key, value);
        }
      });

      const response = await apiClient.patch(`/events/${id}`, formData, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      // Clear related cache entries
      cache.delete('events');
      cache.delete(`event_${id}`);
      
      return response.data;
    } catch (error) {
      if (error instanceof EventServiceError) throw error;
      
      throw new EventServiceError(
        `Failed to update event with ID ${id}`,
        'API_ERROR',
        error
      );
    }
  }

  async getEventClub(clubId) {
    try {
      const cacheKey = `club_events_${clubId}`;
      const cachedData = getCached(cacheKey);
      if (cachedData) return cachedData;

      const response = await apiClient.get(`events/club/${clubId}`);
      const data = response.data;

      if (!Array.isArray(data)) {
        throw new EventServiceError(
          'Invalid response format: expected array',
          'INVALID_RESPONSE'
        );
      }

      setCache(cacheKey, data);
      return data;
    } catch (error) {
      if (error instanceof EventServiceError) throw error;
      
      throw new EventServiceError(
        `Failed to fetch events for club with ID ${clubId}`,
        'API_ERROR',
        error
      );
    }
  }

  async deleteEvent(eventId) {
    try {
      const response = await apiClient.delete(`/events/${eventId}`);
      
      // Clear related cache entries
      cache.delete('events');
      cache.delete(`event_${eventId}`);
      
      return response.data;
    } catch (error) {
      if (error instanceof EventServiceError) throw error;
      
      throw new EventServiceError(
        `Failed to delete event with ID ${eventId}`,
        'API_ERROR',
        error
      );
    }
  }
}

export default new EventService();
