package ute.edu.helper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Formats displayed dates without changing values used by date inputs or filters. */
public class DateDisplayFormatter {
    private static final DateTimeFormatter DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public String format(Object value) {
        if (value == null) return "";
        if (value instanceof LocalDateTime dateTime) return dateTime.format(DATE_TIME);
        if (value instanceof LocalDate date) return date.format(DATE);
        return value.toString();
    }
}
