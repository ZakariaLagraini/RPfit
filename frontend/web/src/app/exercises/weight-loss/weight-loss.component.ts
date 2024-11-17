import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface ExerciseLog {
  date: string;
  setsCompleted: number;
  repsPerSet: number[];
  notes: string;
}

interface Exercise {
  name: string;
  description: string;
  gifUrl: string;
  instructions: string[];
  sets: number;
  reps: string;
  rest: string;
  logs: ExerciseLog[];
  isExpanded?: boolean;
}

interface ExerciseCategory {
  id: string;
  name: string;
  description: string;
  icon: string;
  exercises: Exercise[];
}

@Component({
  selector: 'app-weight-loss',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './weight-loss.component.html'
})
export class WeightLossComponent {
  selectedCategory: ExerciseCategory | null = null;
  exerciseCategories: ExerciseCategory[] = [
    {
      id: 'cardio',
      name: 'Cardio Exercises',
      description: 'High-intensity exercises to maximize calorie burn',
      icon: 'fas fa-running',
      exercises: [
        {
          name: 'Burpees',
          description: 'Full body exercise for maximum calorie burn',
          gifUrl: 'assets/gif/2.jpeg',
          instructions: [
            'Start in a standing position',
            'Drop into a squat position with hands on the ground',
            'Kick your feet back into a plank position',
            'Immediately return your feet to the squat position',
            'Jump up from squatting position with arms extending overhead'
          ],
          sets: 3,
          reps: '15',
          rest: '60',
          logs: [],
          isExpanded: false
        },
        {
          name: 'Mountain Climbers',
          description: 'Dynamic core exercise that raises heart rate',
          gifUrl: 'assets/exercises/gifs/mountain-climbers.gif',
          instructions: [
            'Start in a plank position',
            'Drive one knee toward your chest',
            'Quickly switch legs, like running in place',
            'Keep your core tight and back straight'
          ],
          sets: 4,
          reps: '30s',
          rest: '30',
          logs: [],
          isExpanded: false
        }
      ]
    },
    {
      id: 'hiit',
      name: 'HIIT Workouts',
      description: 'High-Intensity Interval Training for fat burning',
      icon: 'fas fa-bolt',
      exercises: [
        {
          name: 'Jump Squats',
          description: 'Explosive lower body exercise',
          gifUrl: 'assets/exercises/gifs/jump-squats.gif',
          instructions: [
            'Stand with feet shoulder-width apart',
            'Lower into a squat position',
            'Explosively jump upward',
            'Land softly and immediately lower into the next squat'
          ],
          sets: 3,
          reps: '12',
          rest: '45',
          logs: [],
          isExpanded: false
        }
      ]
    },
    {
      id: 'core',
      name: 'Core Strength',
      description: 'Build a strong core while burning calories',
      icon: 'fas fa-dumbbell',
      exercises: [
        {
          name: 'Russian Twists',
          description: 'Rotational core exercise',
          gifUrl: 'assets/exercises/gifs/russian-twists.gif',
          instructions: [
            'Sit with knees bent and feet off the ground',
            'Lean back slightly, keeping back straight',
            'Twist torso from side to side',
            'Keep core engaged throughout'
          ],
          sets: 3,
          reps: '20 each side',
          rest: '45',
          logs: [],
          isExpanded: false
        }
      ]
    }
  ];

  newLog: ExerciseLog = {
    date: new Date().toISOString().split('T')[0],
    setsCompleted: 1,
    repsPerSet: [0],
    notes: ''
  };

  selectCategory(category: ExerciseCategory): void {
    this.selectedCategory = category;
  }

  backToCategories(): void {
    this.selectedCategory = null;
  }

  getArray(n: number): number[] {
    return Array(n).fill(0);
  }

  addSet(): void {
    this.newLog.setsCompleted++;
    this.newLog.repsPerSet.push(0);
  }

  removeSet(): void {
    if (this.newLog.setsCompleted > 1) {
      this.newLog.setsCompleted--;
      this.newLog.repsPerSet.pop();
    }
  }

  logExercise(event: Event, exercise: Exercise): void {
    event.preventDefault();
    if (!exercise.logs) {
      exercise.logs = [];
    }
    exercise.logs.unshift({ ...this.newLog });
    this.newLog = {
      date: new Date().toISOString().split('T')[0],
      setsCompleted: 1,
      repsPerSet: [0],
      notes: ''
    };
  }

  toggleExercise(exercise: Exercise): void {
    // Close all other exercises
    if (this.selectedCategory) {
      this.selectedCategory.exercises.forEach(e => {
        if (e !== exercise) {
          e.isExpanded = false;
        }
      });
    }
    // Toggle the clicked exercise
    exercise.isExpanded = !exercise.isExpanded;
  }
}
