import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-schedule-modal',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './schedule-modal.component.html',
  styleUrls: ['./schedule-modal.component.css']
})
export class ScheduleModalComponent {
  @Input() isOpen = false;
  @Output() closeModal = new EventEmitter<void>();
  @Output() scheduleSession = new EventEmitter<any>();

  session = {
    date: new Date(),
    time: '',
    workoutType: 'strength',
    duration: 60,
    intensity: 'medium',
    notes: '',
    reminder: true,
    trainer: '',
    location: ''
  };

  close() {
    this.closeModal.emit();
  }

  handleSubmit(event: Event) {
    event.preventDefault();
    this.scheduleSession.emit(this.session);
    this.close();
  }
}
