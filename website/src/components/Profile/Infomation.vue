<template>
  <div class="relative min-h-screen animate-gradient-background">
    <!-- Main Content -->
    <div class="relative z-10 flex justify-center items-center min-h-screen py-12 px-4">
      <div class="bg-white/80 backdrop-blur-lg p-8 rounded-2xl shadow-xl w-full max-w-2xl">
        <!-- Profile Header -->
        <div class="flex flex-col items-center">
          <div class="relative group">
            <div class="absolute -inset-0.5 bg-gradient-to-r from-violet-600 to-indigo-600 rounded-full blur opacity-75 group-hover:opacity-100 transition duration-1000"></div>
            <div class="relative">
              <img
                :src="profile?.backgroundImages?.[0]?.image_url || defaultAvatar"
                alt="Profile Picture"
                class="w-32 h-32 rounded-full object-cover border-4 border-white cursor-pointer transform transition-all duration-500 group-hover:scale-105"
                @click="triggerFileInput"
              />
              <div class="absolute bottom-0 right-0 bg-indigo-500 rounded-full p-2 cursor-pointer transform transition-all duration-500 hover:scale-110 hover:bg-indigo-600" @click="triggerFileInput">
                <Camera class="w-5 h-5 text-white" />
              </div>
            </div>
          </div>
          <input type="file" ref="fileInput" @change="onFileSelected" accept="image/*" class="hidden" />
          
          <h2 class="text-3xl font-bold mt-4 text-gray-900">{{ profile.name }}</h2>
          <p class="text-indigo-500 font-medium">{{ profile.studentId }}</p>
        </div>

        <!-- Profile Information -->
        <div class="mt-8 space-y-6">
          <!-- Username -->
          <div class="bg-white/50 backdrop-blur rounded-xl p-4">
            <div class="flex items-center space-x-3">
              <div class="p-2 bg-indigo-100 rounded-lg">
                <User class="w-5 h-5 text-indigo-500" />
              </div>
              <div>
                <p class="text-sm text-gray-500">Username</p>
                <p class="font-medium text-gray-900">{{ profile.username }}</p>
              </div>
            </div>
          </div>

          <!-- Email -->
          <div class="bg-white/50 backdrop-blur rounded-xl p-4">
            <div class="flex items-center space-x-3">
              <div class="p-2 bg-indigo-100 rounded-lg">
                <Mail class="w-5 h-5 text-indigo-500" />
              </div>
              <div>
                <p class="text-sm text-gray-500">Email</p>
                <p class="font-medium text-gray-900">{{ profile.email }}</p>
              </div>
            </div>
          </div>

          <!-- Phone -->
          <div class="bg-white/50 backdrop-blur rounded-xl p-4">
            <div class="flex items-center space-x-3">
              <div class="p-2 bg-indigo-100 rounded-lg">
                <Phone class="w-5 h-5 text-indigo-500" />
              </div>
              <div>
                <p class="text-sm text-gray-500">Phone</p>
                <p class="font-medium text-gray-900">{{ profile.phone || 'Not set' }}</p>
              </div>
            </div>
          </div>

          <!-- Gender -->
          <div class="bg-white/50 backdrop-blur rounded-xl p-4">
            <div class="flex items-center space-x-3">
              <div class="p-2 bg-indigo-100 rounded-lg">
                <Users class="w-5 h-5 text-indigo-500" />
              </div>
              <div>
                <p class="text-sm text-gray-500">Gender</p>
                <p class="font-medium text-gray-900">{{ profile.gender || 'Not set' }}</p>
              </div>
            </div>
          </div>

          <!-- Description -->
          <div class="bg-white/50 backdrop-blur rounded-xl p-4">
            <div class="flex items-start space-x-3">
              <div class="p-2 bg-indigo-100 rounded-lg">
                <FileText class="w-5 h-5 text-indigo-500" />
              </div>
              <div class="flex-1">
                <p class="text-sm text-gray-500">Description</p>
                <p class="font-medium text-gray-900">{{ profile.description || 'No description added yet' }}</p>
              </div>
            </div>
          </div>

          <!-- Update Button -->
          <div class="flex justify-center mt-8">
            <button 
              @click="openUpdateDialog"
              class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-500 text-white rounded-xl font-medium hover:from-indigo-600 hover:to-purple-600 transform hover:scale-105 transition-all duration-300 flex items-center gap-2"
            >
              <Pencil class="w-5 h-5" />
              Update Profile
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Update Dialog -->
    <div v-if="showUpdateDialog" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-2xl p-6 w-full max-w-xl mx-4 transform transition-all">
        <h3 class="text-2xl font-bold text-gray-900 mb-6">Update Profile</h3>
        
        <div class="space-y-4">
          <!-- Avatar Update -->
          <div class="flex flex-col items-center mb-6">
            <div class="relative group">
              <div class="absolute -inset-0.5 bg-gradient-to-r from-violet-600 to-indigo-600 rounded-full blur opacity-75 group-hover:opacity-100 transition duration-1000"></div>
              <div class="relative">
                <img
                  :src="avatarPreview || profile?.backgroundImages?.[0]?.image_url || defaultAvatar"
                  alt="Profile Picture"
                  class="w-24 h-24 rounded-full object-cover border-4 border-white cursor-pointer transform transition-all duration-500 group-hover:scale-105"
                  @click="triggerFileInput"
                />
                <div class="absolute bottom-0 right-0 bg-indigo-500 rounded-full p-2 cursor-pointer transform transition-all duration-500 hover:scale-110 hover:bg-indigo-600" @click="triggerFileInput">
                  <Camera class="w-4 h-4 text-white" />
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-500 mt-2">Click to change avatar</p>
          </div>

          <!-- Username Input -->
          <div>
            <label class="text-sm text-gray-500">Username</label>
            <input
              v-model="editableData.username"
              class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all"
              placeholder="Enter username"
            />
          </div>

          <!-- Phone Input -->
          <div>
            <label class="text-sm text-gray-500">Phone</label>
            <input
              v-model="editableData.phone"
              class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all"
              placeholder="Enter phone number"
            />
          </div>

          <!-- Gender Select -->
          <div>
            <label class="text-sm text-gray-500">Gender</label>
            <select
              v-model="editableData.gender"
              class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all"
            >
              <option value="male">Male</option>
              <option value="female">Female</option>
              <option value="other">Other</option>
            </select>
          </div>

          <!-- Description Textarea -->
          <div>
            <label class="text-sm text-gray-500">Description</label>
            <textarea
              v-model="editableData.description"
              rows="4"
              class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all"
              placeholder="Tell us about yourself"
            ></textarea>
          </div>
        </div>

        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="closeUpdateDialog"
            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
          >
            Cancel
          </button>
          <button 
            @click="saveAllChanges"
            class="px-4 py-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600 transition-colors"
          >
            Save Changes
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useAuthStore } from "../../stores/authStore.js";
import BackgroundImageService from "../../services/backgroundImage";
import { updateInfo } from "../../services/user";
import { 
  Pencil, 
  Camera, 
  User, 
  Mail, 
  Phone, 
  Users,
  FileText
} from "lucide-vue-next";
import defaultAvatar from "../../assets/1.webp";

const authStore = useAuthStore();
const profile = computed(() => {
  const userData = localStorage.getItem('user');
  return userData ? JSON.parse(userData) : null;
});
const fileInput = ref(null);
const showUpdateDialog = ref(false);
const avatarPreview = ref(null);
const avatarFile = ref(null);

const editableData = ref({
  username: "",
  phone: "",
  gender: "",
  description: "",
});

onMounted(async () => {
  await authStore.fetchUserInfo();
});

const openUpdateDialog = () => {
  editableData.value = {
    username: profile.value.username || "",
    phone: profile.value.phone || "",
    gender: profile.value.gender || "",
    description: profile.value.description || "",
  };
  avatarPreview.value = null;
  showUpdateDialog.value = true;
};

const closeUpdateDialog = () => {
  showUpdateDialog.value = false;
  avatarPreview.value = null;
  avatarFile.value = null;
};

const saveAllChanges = async () => {
  try {
    // First update profile info
    await updateInfo(profile.value.id, editableData.value);
    
    // Then if there's a new avatar, upload it
    if (avatarFile.value) {
      // If user already has an avatar, delete it first
      if (profile.value.backgroundImages?.length > 0) {
        await BackgroundImageService.deleteImage(profile.value.backgroundImages[0].id);
      }
      
      // Upload new avatar
      const formData = new FormData();
      formData.append("image", avatarFile.value);
      await BackgroundImageService.uploadImage(avatarFile.value);
    }
    
    // Update local storage with new data
    const userData = JSON.parse(localStorage.getItem('user'));
    const updatedUser = {
      ...userData,
      ...editableData.value
    };
    localStorage.setItem('user', JSON.stringify(updatedUser));
    
    showUpdateDialog.value = false;
    avatarPreview.value = null;
    avatarFile.value = null;

    alert("Profile updated successfully!");
  } catch (error) {
    console.error("Error updating profile:", error);
    alert("Failed to update profile. Please try again.");
  }
};

const triggerFileInput = () => {
  if (showUpdateDialog.value) {
    fileInput.value.click();
  }
};

const onFileSelected = async (event) => {
  const file = event.target.files[0];
  if (file) {
    // Validate file type
    if (!file.type.startsWith('image/')) {
      alert('Please select an image file');
      return;
    }
    
    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      alert('Image size should not exceed 5MB');
      return;
    }

    avatarFile.value = file;
    avatarPreview.value = URL.createObjectURL(file);
    
    if (!showUpdateDialog.value) {
      try {
        // If user already has an avatar, delete it first
        if (profile.value.backgroundImages?.length > 0) {
          await BackgroundImageService.deleteImage(profile.value.backgroundImages[0].id);
        }
        
        // Upload new avatar
        const formData = new FormData();
        formData.append("image", file);
        await BackgroundImageService.uploadImage(file);
        
        // Refresh user data
        await authStore.fetchUserInfo();
        
        // Clear the preview and file
        avatarPreview.value = null;
        avatarFile.value = null;
        
        alert("Avatar updated successfully!");
      } catch (error) {
        console.error("Error uploading image:", error);
        alert("Failed to update avatar. Please try again.");
      }
    }
  }
};
</script>

<style scoped>
@keyframes gradient {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.animate-gradient-background {
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  background-size: 400% 400%;
  animation: gradient 15s ease infinite;
}

/* Input Focus Styles */
input:focus, textarea:focus, select:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(to bottom, #6366f1, #4f46e5);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(to bottom, #4f46e5, #6366f1);
}

/* Smooth Scrolling */
html {
  scroll-behavior: smooth;
}
</style>
