package com.unical.repository;

import com.unical.domain.CalendarEntity;
import com.unical.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CalendarRepository extends JpaRepository<CalendarEntity, Long> {
    List<CalendarEntity> findByUser(User user);
}
