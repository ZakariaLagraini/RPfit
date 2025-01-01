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
      imageUrl: 'assets/exercises/bench-press.gif',
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
      imageUrl: 'assets/exercises/squats.gif',
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