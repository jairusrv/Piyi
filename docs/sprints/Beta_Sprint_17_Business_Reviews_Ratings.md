# BETA Sprint 17 - Reseñas y Calificaciones

## Backend

- BusinessReview
- BusinessReviewConfiguration
- DTOs
- IBusinessReviewService
- BusinessReviewService
- BusinessReviewsController

## Flutter

- BusinessReview model
- Repository
- Providers
- Widgets de resumen, listado y creación

## Endpoints

GET /api/businesses/{businessId}/reviews
GET /api/businesses/{businessId}/reviews/summary
POST /api/businesses/{businessId}/reviews
POST /api/businesses/{businessId}/reviews/{reviewId}/reply
POST /api/businesses/{businessId}/reviews/{reviewId}/report
DELETE /api/businesses/{businessId}/reviews/{reviewId}

## Definition of Done

- Usuario puede ver reseñas.
- Usuario puede calificar 1 a 5.
- Usuario puede comentar.
- Negocio puede responder.
- Usuario puede reportar reseña.
