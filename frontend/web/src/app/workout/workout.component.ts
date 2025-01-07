import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface Workout {
  name: string;
  imageUrl: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  description: string;
  duration: number;
  calories: number;
  equipment: string[];
  targetMuscles: string[];
  sets: number;
  reps: number;
  restTime: number;
  videoUrl?: string;
  tips: string[];
  variations: string[];
  isExpanded: boolean;
}

@Component({
  selector: 'app-workout',
  standalone: true,
  imports: [
    CommonModule, 
    RouterModule,
    FormsModule
  ],
  templateUrl: './workout.component.html',
  styleUrls: ['./workout.component.css']
})
export class WorkoutComponent {
  workouts: Workout[] = [
    {
      name: 'Bench Press',
      imageUrl: 'assets/gif/bench-press.gif',
      difficulty: 'intermediate',
      description: 'Fundamental chest exercise for building upper body strength',
      duration: 10,
      calories: 200,
      equipment: ['Barbell'],
      targetMuscles: ['Chest'],
      sets: 4,
      reps: 12,
      restTime: 90,
      tips: ['Keep your elbows close to your body', 'Lower the bar slowly'],
      variations: ['Incline Bench Press', 'Decline Bench Press'],
      isExpanded: false
    },
    {
      name: 'Squats',
      imageUrl: 'assets/gif/goblet-squad.gif',
      difficulty: 'intermediate',
      description: 'Compound exercise targeting lower body muscles',
      duration: 10,
      calories: 150,
      equipment: ['Body weight'],
      targetMuscles: ['Legs'],
      sets: 4,
      reps: 12,
      restTime: 90,
      tips: ['Keep your back straight', 'Lower your body slowly'],
      variations: ['Front Squats', 'Sumo Squats'],
      isExpanded: false
    },
    {
      name: 'Deadlift',
      imageUrl: 'assets/gif/deadlift.gif',
      difficulty: 'advanced',
      description: 'A compound exercise that targets multiple muscle groups, particularly the posterior chain',
      duration: 15,
      calories: 250,
      equipment: ['Barbell', 'Weight Plates'],
      targetMuscles: ['Back', 'Legs', 'Core'],
      sets: 4,
      reps: 8,
      restTime: 120,
      tips: ['Keep your back straight', 'Push through your heels', 'Engage your core'],
      variations: ['Romanian Deadlift', 'Sumo Deadlift', 'Single-leg Deadlift'],
      isExpanded: false
    },
    {
      name: 'Pull-ups',
      imageUrl: 'assets/gif/pull-ups.gif',
      difficulty: 'advanced',
      description: 'Upper body exercise focusing on back and arm strength',
      duration: 10,
      calories: 100,
      equipment: ['Pull-up Bar'],
      targetMuscles: ['Back', 'Biceps', 'Shoulders'],
      sets: 3,
      reps: 8,
      restTime: 90,
      tips: ['Start from a dead hang', 'Pull your chest to the bar', 'Control the descent'],
      variations: ['Chin-ups', 'Wide-grip Pull-ups', 'Negative Pull-ups'],
      isExpanded: false
    },
    {
      name: 'Push-ups',
      imageUrl: 'assets/gif/push-ups.gif',
      difficulty: 'beginner',
      description: 'Classic bodyweight exercise for upper body strength',
      duration: 8,
      calories: 80,
      equipment: ['None'],
      targetMuscles: ['Chest', 'Shoulders', 'Triceps'],
      sets: 3,
      reps: 15,
      restTime: 60,
      tips: ['Keep your body straight', 'Hands shoulder-width apart', 'Lower chest to ground'],
      variations: ['Diamond Push-ups', 'Wide Push-ups', 'Incline Push-ups'],
      isExpanded: false
    },
    {
      name: 'Dumbbell Rows',
      imageUrl: 'assets/gif/dumbbell-rows.gif',
      difficulty: 'intermediate',
      description: 'Unilateral back exercise for strength and muscle development',
      duration: 12,
      calories: 150,
      equipment: ['Dumbbells', 'Bench'],
      targetMuscles: ['Back', 'Biceps'],
      sets: 4,
      reps: 12,
      restTime: 90,
      tips: ['Keep your back parallel to ground', 'Pull dumbbell to hip', 'Control the movement'],
      variations: ['Barbell Rows', 'Meadows Row', 'Pendlay Row'],
      isExpanded: false
    }
    // Add more exercises as needed
  ];

  difficultyLevels = ['beginner', 'intermediate', 'advanced'];
  selectedDifficulty: string = '';
  searchTerm: string = '';
  sortBy: string = 'name';

  constructor(private location: Location) {}

  goBack(): void {
    this.location.back();
  }

  toggleExercise(exercise: Workout): void {
    exercise.isExpanded = !exercise.isExpanded;
  }

  get filteredWorkouts() {
    return this.workouts
      .filter(w => !this.selectedDifficulty || w.difficulty === this.selectedDifficulty)
      .filter(w => !this.searchTerm || 
        w.name.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        w.description.toLowerCase().includes(this.searchTerm.toLowerCase()))
      .sort((a, b) => {
        if (this.sortBy === 'duration') return a.duration - b.duration;
        if (this.sortBy === 'calories') return a.calories - b.calories;
        return a.name.localeCompare(b.name);
      });
  }

  filterByDifficulty(level: string) {
    this.selectedDifficulty = this.selectedDifficulty === level ? '' : level;
  }

  getDifficultyClass(difficulty: 'beginner' | 'intermediate' | 'advanced'): string {
    const classes: Record<'beginner' | 'intermediate' | 'advanced', string> = {
      'beginner': 'bg-green-100 text-green-800',
      'intermediate': 'bg-yellow-100 text-yellow-800',
      'advanced': 'bg-red-100 text-red-800'
    };
    return classes[difficulty];
  }

  showWorkoutDetails(workout: Workout) {
    // Implement modal or navigation to detailed view
  }
}